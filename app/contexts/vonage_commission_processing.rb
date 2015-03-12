class VonageCommissionProcessing
  def process(paycheck = nil)
    @paycheck = paycheck || get_paycheck
    return unless @paycheck
    generate_payouts
    change_manager_payouts
    clear_existing_payouts
    save_payouts
    process_negative_balances
    self
  end

  private

  def generate_payouts
    @all_payouts = []
    @all_sales = VonageSale.for_paycheck(@paycheck).where(resold: false)
    determine_weeks
    split_sales_into_weeks
    generate_payouts_for_weeks
    self
  end

  def generate_payouts_for_weeks
    return unless @week_sales
    for week_sales in @week_sales do
      @sales = week_sales
      set_people_with_sales
      set_sale_count_for_each_person
      set_bracket_area_for_each_person
      set_bracket_for_each_person
      make_payouts_from_counts
      next unless @payouts
      @all_payouts = @all_payouts.concat(@payouts).compact
    end
  end

  def clear_existing_payouts
    VonageSalePayout.where(vonage_paycheck: @paycheck).destroy_all
    self
  end

  def save_payouts
    return unless @all_payouts
    @all_payouts.compact!
    @all_payouts.each { |payout| payout.save }
    self
  end

  def process_negative_balances
    gather_person_list_for_balances
    self
  end

  def gather_person_list_for_balances
    return unless @people_with_sales
    @person_list_for_balances = @people_with_sales
    gather_people_with_refunds
    gather_people_with_balances
    @person_list_for_balances.uniq!
    make_negative_payout_hashes
    apply_negative_payout_hashes
  end

  def gather_people_with_refunds
    for refund in @paycheck.refunds do
      @person_list_for_balances << refund.person
    end
  end

  def gather_people_with_balances
    for balance in @paycheck.get_previous.vonage_paycheck_negative_balances do
      @person_list_for_balances << balance.person
    end
  end

  def make_negative_payout_hashes
    @negative_payout_hashes = []
    for person in @person_list_for_balances do
      payout_hash = {
          person: person,
          net_last_paycheck: @paycheck.get_previous.net_payout(person)
      }
      @negative_payout_hashes << payout_hash if payout_hash[:net_last_paycheck] < 0
    end
  end

  def apply_negative_payout_hashes
    return unless @negative_payout_hashes
    clear_existing_negative_balances
    for negative_hash in @negative_payout_hashes do
      create_negative_balance(negative_hash)
    end
  end

  def clear_existing_negative_balances
    @paycheck.vonage_paycheck_negative_balances.destroy_all
  end

  def create_negative_balance(negative_hash)
    balance = VonagePaycheckNegativeBalance.create vonage_paycheck: @paycheck,
                                         balance: negative_hash[:net_last_paycheck],
                                         person: negative_hash[:person]
    self
  end

  def determine_weeks
    start_date = @paycheck.commission_start
    end_date = @paycheck.commission_end
    @weeks = []
    current_start = start_date
    while current_start < end_date
      @weeks << [current_start, current_start + 6.days]
      current_start += 1.week
    end
    self
  end

  def split_sales_into_weeks
    return unless @weeks
    @week_sales = []
    for week in @weeks do
      @week_sales << @all_sales.where('sale_date >= ? AND sale_date <= ?',
                                week[0], week[1])

    end
    self
  end

  def set_people_with_sales
    @people_with_sales = []
    for sale in @sales do
      @people_with_sales << sale.person
    end
    @people_with_sales.uniq!
    self
  end

  def set_sale_count_for_each_person
    return unless @people_with_sales
    @person_sale_counts = []
    for person in @people_with_sales do
      @person_sale_counts << {
          person: person,
          sales: @sales.where(person: person).count
      }
    end
    self
  end

  def set_bracket_area_for_each_person
    return unless @person_sale_counts
    person_counts_with_area = []
    for person_sale_count in @person_sale_counts do
      bracket_area = get_bracket_area(person_sale_count[:person]) || next
      person_counts_with_area << person_sale_count.merge(bracket_area: bracket_area)
    end
    @person_sale_counts = person_counts_with_area
    self
  end

  def get_bracket_area(person)
    for person_area in person.person_areas do
      ancestors = person_area.area.ancestors
      for ancestor in ancestors.reverse do
        return ancestor unless ancestor.vonage_rep_sale_payout_brackets.empty?
      end
    end
    nil
  end

  def set_bracket_for_each_person
    return unless @person_sale_counts
    person_counts_with_bracket = []
    for person_sale_count in @person_sale_counts do
      bracket = get_bracket(person_sale_count) || next
      person_counts_with_bracket << person_sale_count.merge(bracket: bracket)
    end
    @person_sale_counts = person_counts_with_bracket
    self
  end

  def change_manager_payouts
    determine_vonage_managers
    change_vonage_manager_payout_amounts
    self
  end

  def determine_vonage_managers
    @vonage_managers = []
    projects = [Project.find_by(name: 'Vonage Retail'), Project.find_by(name: 'Vonage Events')]
    for project in projects do
      for area in project.areas do
        management_person_areas = area.person_areas.where(manages: true)
        @vonage_managers += management_person_areas.map(&:person)
      end
    end
    @vonage_managers = @vonage_managers.flatten.compact
    self
  end

  def change_vonage_manager_payout_amounts
    return unless @all_payouts and @vonage_managers
    for payout in @all_payouts do
      change_payout_amount_for_manager(payout) if @vonage_managers.include?(payout.person)
    end
    self
  end

  def change_payout_amount_for_manager(payout)
    payout.payout = 20.00
    self
  end

  def get_bracket(person_sale_count)
    area = person_sale_count[:bracket_area] || return
    count = person_sale_count[:sales]
    brackets = area.
        vonage_rep_sale_payout_brackets.where('sales_minimum <= ? AND sales_maximum >= ?',
                                              count, count)
    return if brackets.empty?
    brackets.first
  end

  def make_payouts_from_counts
    return unless @person_sale_counts
    @payouts = []
    for person_count in @person_sale_counts do
      payouts = make_payouts_from_count(person_count) || next
      @payouts = @payouts.concat payouts
    end
    self
  end

  def make_payouts_from_count(person_count)
    payouts = []
    person = person_count[:person] || return
    bracket = person_count[:bracket] || return
    for sale in @sales.where(person: person) do
      payouts << make_payout(person, sale, bracket.per_sale)
    end
    payouts
  end

  def make_payout(person, sale, amount)
    VonageSalePayout.new person: person,
                         vonage_sale: sale,
                         payout: amount,
                         vonage_paycheck: @paycheck
  end

  module PaycheckDetermination
    def get_paycheck
      paychecks = VonagePaycheck.where('cutoff > ?', DateTime.now).
          order(:cutoff)
      return if paychecks.empty?
      paychecks.first
    end
  end

  include PaycheckDetermination
end