class UQubeSalesSource
  def initialize start_date_time, end_date_time
    @sales = VonageSale.where "created_at >= ? AND created_at < ?", start_date_time, end_date_time
  end

  def each
    @sales.each do |s|
      yield s
    end
  end
end