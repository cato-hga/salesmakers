class ConnectSprintSalesSource
  def initialize duration
    sales_after = (Time.now - duration).apply_eastern_offset
    @sales = ConnectSprintSale.where "created >= ?", sales_after
  end

  def each
    @sales.each do |sale|
      yield sale.attributes
    end
  end
end