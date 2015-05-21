module RevenueSharing

  private

  def generate_revenue_sharing_payouts
    @revenue_sharing_payouts = []
    generate_payouts_for_milestone(62, 2.50, 10)
    generate_payouts_for_milestone(92, 2.50, 3)
    generate_payouts_for_milestone(122, 2.50, 2)
    generate_payouts_for_milestone(152, 2.50, 10)
    @all_payouts = @all_payouts.concat(@revenue_sharing_payouts).compact
  end

  def generate_payouts_for_milestone(days, retail_payout_amount, pilot_payout_amount)
    sales = VonageSale.for_date_range(@paycheck.commission_start - days.days,
                                      @paycheck.commission_end - days.days)
    process_revenue_sharing_payout_for_sales(sales, days, retail_payout_amount, pilot_payout_amount)
  end

  def process_revenue_sharing_payout_for_sales(sales, days, retail_payout_amount, pilot_payout_amount)
    return unless sales
    for sale in sales do
      next unless sale.still_active_on?(sale.sale_date + days.days - 1.day)
      process_revenue_sharing_payout_for_sale sale, days, retail_payout_amount, pilot_payout_amount
    end
  end

  def process_revenue_sharing_payout_for_sale(sale, days, retail_payout_amount, pilot_payout_amount)
    return unless sale.person.active?
    payout = make_revenue_sharing_payout(sale, retail_payout_amount, pilot_payout_amount)
    return unless payout
    case days
      when 62
        payout.day_62 = true
      when 92
        payout.day_92 = true
      when 122
        payout.day_122 = true
      when 152
        payout.day_152 = true
    end
    @revenue_sharing_payouts << payout if payout
  end


  def make_revenue_sharing_payout(sale, retail_payout_amount, pilot_payout_amount)
    person_areas = sale.person.person_areas
    pilot = false
    if not person_areas.empty? and person_areas.first.area.name.downcase.include?('pilot ')
      pilot = true
    end
    VonageSalePayout.new person: sale.person,
                         vonage_sale: sale,
                         payout: pilot ? pilot_payout_amount : retail_payout_amount,
                         vonage_paycheck: @paycheck
  end
end