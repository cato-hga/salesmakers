def do_transformation
  @count = 0

  @headers = [
      'MAC_ID',
      'ACCOUNT_NUMBER',
      'ONLINE_ORDER_NUM',
      'SOLD_DATE',
      'SOLD_TIME',
      'CUST_TYPE',
      'CURRENT_PROMOTION',
      'DM_MODIFIED_MULTI_LINE',
      'PLAN_NAME',
      'DEVICE_NAME',
      'PAYMENT_METHOD',
      'EVENT_FLAG',
      'ZIP_CODE',
      'COUNTRIES_CALL_MOST',
      'HOW_HEAR_ABOUT',
      'SALES_REP_NAME',
      'SALES_REP_ID',
      'MANAGER_NAME',
      'MANAGER_ID',
      'KIOSK_NAME',
      'KIOSK_ID',
      'MARKET_NAME',
      'MARKET_ID',
      'REGION_NAME',
      'REGION_ID',
      'CLIENT_AREA',
      'COUNTRY_CODE',
      'COMMENTS',
      'CATEGORY',
      'EVENT_NAME'
  ]

  transform do |sale|
    @count += 1
    supervisors = sale.person.direct_supervisors.where.not(email: 'kgadd@retaildoneright.com')
    supervisor = supervisors.empty? ? nil : supervisors.first
    location_area = LocationArea.for_project_and_location(Project.find_by(name: 'Vonage Retail'), sale.location).first
    territory = location_area ? location_area.area : nil
    market = territory ? territory.parent : nil
    region = market ? market.parent : nil
    first_shift_from_person_on_day = sale.person.shifts.where(date: sale.sale_date).first
    row = [
        sale.mac,
        '',
        sale.confirmation_number,
        sale.sale_date.strftime('%m/%d/%Y'),
        '00:00:00',
        'New',
        '',
        'FALSE',
        '',
        '',
        '',
        sale.location.channel.name.downcase.include?('event team') ? 'TRUE' : 'FALSE',
        '',
        '',
        '',
        NameCase(sale.person.display_name),
        sale.person.id,
        supervisor ? NameCase(supervisor.display_name) : 'TBD',
        supervisor ? supervisor.id : 'TBD',
        sale.location.name,
        sale.location.channel.name == 'Walmart' ? sale.location.store_number : sale.location.id,
        market ? market.name : 'N/A',
        market ? market.id : 'N/A',
        region ? region.name : 'N/A',
        region ? region.id : 'N/A',
        territory ? territory.name : 'N/A',
        'USA',
        '',
        sale.location.channel.name.downcase.include?('event team') ? 'Event' : 'Retail',
        first_shift_from_person_on_day && sale.location.channel.name.downcase.include?('event team') ? first_shift_from_person_on_day.note : ''
    ]

    row
  end
end