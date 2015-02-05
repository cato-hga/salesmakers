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
    days = Hash.new
    for order in orders do
      if order.is_a? ConnectOrder
        sold = (order.dateordered - 3.hours).to_date
      else
        sold = (order.date_sold).to_date
      end
      next if sold < @start_date or sold > @end_date
      unless days.include? sold
        days[sold] = Hash.new
        days[sold]['areas'] = Hash.new
        days[sold]['people'] = Hash.new
        days[sold]['projects'] = Hash.new
        days[sold]['clients'] = Hash.new
      end
      area = nil
      person = nil
      project = nil
      client = nil
      area = order.area
      person = order.person
      project = area ? area.project : nil
      client = project ? project.client : nil
      if area
        areas = area.path
        for path_area in areas do
          days[sold]['areas'][path_area] = 0 unless days[sold]['areas'].include? path_area
          days[sold]['areas'][path_area] += 1
        end
      end
      if person
        days[sold]['people'][person] = 0 unless days[sold]['people'].include? person
        days[sold]['people'][person] += 1
      end
      if project
        days[sold]['projects'][project] = 0 unless days[sold]['projects'].include? project
        days[sold]['projects'][project] += 1
      end
      if client
        days[sold]['clients'][client] = 0 unless days[sold]['clients'].include? client
        days[sold]['clients'][client] += 1
      end
    end

    for day in days.keys
      for saleable_key in days[day].keys do
        for o in days[day][saleable_key].keys do
          day_sales = DaySalesCount.find_or_initialize_by saleable: o,
                                                          day: day
          day_sales.sales = days[day][saleable_key][o]
          day_sales.updated_at = Time.now
          day_sales.save
        end
      end
    end
  end

  #:nocov:
end