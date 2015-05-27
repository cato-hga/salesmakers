class SaleImporter
  #:nocov:
  def initialize(start_date = (Time.zone.now - 1.month).to_date, end_date = Time.zone.now.to_date)
    started = Time.now
    @start_date = start_date
    @end_date = end_date
    @count = 0
    import_vonage
    import_sprint
    DaySalesCount.where('day >= ? AND day <= ? AND updated_at < ?',
                        @start_date,
                        @end_date,
                        started).destroy_all
    ProcessLog.create process_class: self.class.name, records_processed: @count
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
      process_object sold, sale, get_details(sale)[:person]
      process_object sold, sale, get_details(sale)[:project]
      process_object sold, sale, get_details(sale)[:client]
      process_object sold, sale, get_details(sale)[:location_area]
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

  def process_area(sold, sale)
    area = sale.area
    activated = activation? sale
    new_account = new_account? sale
    if area
      areas = area.path
      for path_area in areas do
        increment_object_sale_count sold, 'areas', path_area, activated, new_account
      end
    end
  end

  def process_object(sold, sale, obj)
    return unless obj
    activated = activation? sale
    new_account = new_account? sale
    if obj
      table_name = obj.model_name.name.underscore.pluralize.downcase
      increment_object_sale_count sold, table_name, obj, activated, new_account
    end
  end

  def increment_object_sale_count sold, table_name, obj, activated = false, new_account = false
    unless @days[sold][table_name].include? obj
      @days[sold][table_name][obj] = {
          sales: 0,
          activations: 0,
          new_accounts: 0
      }
    end
    @days[sold][table_name][obj][:sales] += 1
    @days[sold][table_name][obj][:activations] += 1 if activated
    @days[sold][table_name][obj][:new_accounts] += 1 if new_account
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
      day_sales.sales = @days[day][saleable_key][o][:sales]
      day_sales.activations = @days[day][saleable_key][o][:activations]
      day_sales.new_accounts = @days[day][saleable_key][o][:new_accounts]
      day_sales.updated_at = Time.now
      @count += 1 if day_sales.save
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
        location_area: location_area
    }
  end

  def activation?(sale)
    if sale.attributes.keys.include?('phone_activated_in_store')
      sale.phone_activated_in_store?
    else
      false
    end
  end

  def new_account?(sale)
    if sale.attributes.keys.include?('upgrade')
      sale.upgrade? ? false : true
    else
      true
    end
  end
  #:nocov:
end