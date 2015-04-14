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
    orders = ConnectOrder.where("dateordered >= ? AND dateordered < ? AND documentno LIKE '%+'",
                                @start_date.to_time.apply_eastern_offset +
                                    3.hours,
                                @end_date.to_time.apply_eastern_offset +
                                    1.day +
                                    3.hours).
        includes(:connect_user,
                 connect_business_partner_location: :connect_business_partner_location)
    import_orders orders
  end

  def import_sprint
    orders = ConnectSprintSale.where("date_sold >= ? AND date_sold < ?",
                                     @start_date.to_time.apply_eastern_offset,
                                     @end_date.to_time.apply_eastern_offset + 1.day).
        includes(:connect_user,
                 :connect_business_partner_location)
    import_orders orders
  end

  def import_orders(orders)
    @days = Hash.new
    for order in orders do
      sold = get_sale_date(order)
      next if sold < @start_date or sold > @end_date
      initialize_hashes(sold) unless @days.include? sold
      process_area(sold, order)
      process_person(sold, order)
      process_project(sold, order)
      process_client(sold, order)
    end
    process_days
  end

  def get_sale_date(order)
    if order.is_a? ConnectOrder
      (order.dateordered - 3.hours).to_date
    else
      (order.date_sold).to_date
    end
  end

  def initialize_hashes(sold)
    @days[sold] = Hash.new
    @days[sold]['areas'] = Hash.new
    @days[sold]['people'] = Hash.new
    @days[sold]['projects'] = Hash.new
    @days[sold]['clients'] = Hash.new
  end

  def process_area(sold, order)
    area = order.area
    if area
      areas = area.path
      for path_area in areas do
        @days[sold]['areas'][path_area] = 0 unless @days[sold]['areas'].include? path_area
        @days[sold]['areas'][path_area] += 1
      end
    end
  end

  def process_person(sold, order)
    person = order.person
    if person
      @days[sold]['people'][person] = 0 unless @days[sold]['people'].include? person
      @days[sold]['people'][person] += 1
    end
  end

  def process_project(sold, order)
    area = order.area
    project = area ? area.project : nil
    if project
      @days[sold]['projects'][project] = 0 unless @days[sold]['projects'].include? project
      @days[sold]['projects'][project] += 1
    end
  end

  def process_client(sold, order)
    area = order.area
    project = area ? area.project : nil
    client = project ? project.client : nil
    if client
      @days[sold]['clients'][client] = 0 unless @days[sold]['clients'].include? client
      @days[sold]['clients'][client] += 1
    end
  end

  def process_days
    @days.keys.each { |day| process_day day }
  end

  def process_day day
    @days[day].keys.each { |saleable_key| process_orders_for_day day, saleable_key }
  end

  def process_orders_for_day(day, saleable_key)
    for o in @days[day][saleable_key].keys do
      day_sales = DaySalesCount.find_or_initialize_by saleable: o,
                                                      day: day
      day_sales.sales = @days[day][saleable_key][o]
      day_sales.updated_at = Time.now
      day_sales.save
    end
  end
  #:nocov:
end