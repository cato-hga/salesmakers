class VonageCommissionProcessing
  def process(paycheck = nil)
    @paycheck = paycheck || get_paycheck
    return unless @paycheck
    generate_payouts
    clear_existing_payouts
    save_payouts
    self
  end

  private

  def generate_payouts
    @sales = VonageSale.for_paycheck(@paycheck)
    set_people_with_sales
    set_sale_count_for_each_person
    set_bracket_area_for_each_person
    set_bracket_for_each_person
    make_payouts_from_counts
    self
  end

  def clear_existing_payouts
    VonageSalePayout.where(vonage_paycheck: @paycheck).destroy_all
    self
  end

  def save_payouts
    return unless @payouts
    @payouts.compact!
    @payouts.each { |payout| payout.save }
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