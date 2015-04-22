class SaleImporter
  #:nocov:
  def initialize(start_date = (Time.zone.now - 1.month).to_date, end_date = Time.zone.now.to_date)
    @start_date = start_date
    @end_date = end_date
    import_vonage
    import_sprint
    DaySalesCount.where('day >= ? AND day <= ? AND updated_at < ?',
                        @start_date,
                        @end_date,
                        Time.now - 15.minutes).destroy_all

  end

  private

  def import_vonage
    sales = VonageSale.where("sale_date >= ? AND sale_date <= ?",
                                @start_date,
                                @end_date).
        includes(:person,
                 :location)
    import_sales sales
  end

  def import_sprint
    sales = SprintSale.where("sale_date >= ? AND sale_date <= ?",
                              @start_date,
                              @end_date).
        includes(:person,
                 :location)
    import_sales sales
  end

  def import_sales(sales)
    @days = Hash.new
    for sale in sales do
      sold = sale.sale_date
      next if sold < @start_date or sold > @end_date
      initialize_hashes(sold) unless @days.include? sold
      process_area sold, sale
      process_object sold, get_details(sale)[:person]
      process_object sold, get_details(sale)[:project]
      process_object sold, get_details(sale)[:client]
      process_object sold, get_details(sale)[:location_area]
    end
    process_days
  end

  def initialize_hashes(sold)
    @days[sold] = Hash.new
    @days[sold]['areas'] = Hash.new
    @days[sold]['people'] = Hash.new
    @days[sold]['projects'] = Hash.new
    @days[sold]['clients'] = Hash.new
    @days[sold]['location_areas'] = Hash.new
  end

  def process_area(sold, order)
    area = order.area
    if area
      areas = area.path
      for path_area in areas do
        increment_object_sale_count sold, 'areas', path_area
      end
    end
  end

  def process_object(sold, obj)
    return unless obj
    if obj
      table_name = obj.model_name.name.pluralize.downcase
      increment_object_sale_count sold, table_name, obj
    end
  end

  def increment_object_sale_count sold, table_name, obj
    @days[sold][table_name][obj] = 0 unless @days[sold][table_name].include? obj
    @days[sold][table_name][obj] += 1
  end

  def process_days
    @days.keys.each { |day| process_day day }
  end

  def process_day day
    @days[day].keys.each { |saleable_key| process_sales_for_day day, saleable_key }
  end

  def process_sales_for_day(day, saleable_key)
    for o in @days[day][saleable_key].keys do
      day_sales = DaySalesCount.find_or_initialize_by saleable: o,
                                                      day: day
      day_sales.sales = @days[day][saleable_key][o]
      day_sales.updated_at = Time.now
      day_sales.save
    end
  end

  def get_details(sale)
    area = sale.area
    project = area ? area.project : nil
    client = project ? project.client : nil
    location_area = sale.location_area
    {
        person: sale.person,
        area: sale.area,
        project: project,
        client: client,
        location: location_area
    }
  end
  #:nocov:
end