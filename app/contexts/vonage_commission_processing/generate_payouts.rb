module GeneratePayouts

  private

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

  def generate_payouts
    @all_payouts = []
    @all_sales = VonageSale.for_paycheck(@paycheck).where(resold: false)
    determine_weeks
    split_sales_into_weeks
    generate_payouts_for_weeks
    generate_revenue_sharing_payouts
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
end