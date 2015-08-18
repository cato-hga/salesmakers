class VonageSalesSource
  def initialize start_date, end_date
    @gross_sales = VonageSale.for_date_range start_date, end_date
  end

  def each
    @gross_sales.each do |s|
      yield s
    end
  end
end