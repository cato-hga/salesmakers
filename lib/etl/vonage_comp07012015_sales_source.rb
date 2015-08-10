class VonageComp07012015SalesSource
  def initialize start_date_attribute, end_date_attribute
    @period = get_commission_period
    if @period and @period[start_date_attribute] and @period[end_date_attribute]
      @sales = VonageSale.for_date_range @period[start_date_attribute], @period[end_date_attribute]
    else
      @sales = []
    end
  end

  def each
    @sales.each do |sale|
      yield sale.attributes.merge({ vonage_commission_period07012015_id: @period.id })
    end
  end

  private

  def get_commission_period
    periods = VonageCommissionPeriod07012015.where("cutoff > ?", DateTime.now).order(:cutoff)
    return nil if periods.empty?
    periods.first
  end
end