module VonageGroupMeBotSalesQuery
  protected

  def sales_wrap_query(query)
    "SELECT * FROM (" + query + ") everything ORDER BY everything.count DESC"
  end

  def sales_where_clause
    "WHERE vonage_sales.sale_date >= CAST('#{self.start_date}' AS DATE) AND " +
        "vonage_sales.sale_date < CAST('#{self.end_date}' AS DATE) AND " +
        sales_parameter_where_clause
  end

  def sales_parameter_where_clause
    output = ""
    case @level
      #IF ELSE FOR ALL MARKETS/REGIONS
      when "rep"
        output += "region.name ILIKE '%#{query_string}%' AND "
      when "territory"
        output += "areas.name ILIKE '%#{query_string}%' AND "
      when "market"
        output += "market.name ILIKE '%#{query_string}%' AND "
      when "region"
        output += "region.name ILIKE '%#{query_string}%' AND "
    end
    output += "areas.ancestry like '%/%' AND " +
        "vonage_sales.sale_date >= CAST('#{self.start_date}' AS DATE) AND " +
        "vonage_sales.sale_date < CAST('#{self.end_date}' AS DATE) "
  end

  def sales_every_from_and_join
    <<EOF
      FROM vonage_sales
      LEFT OUTER JOIN people
        ON people.id = vonage_sales.person_id
      LEFT OUTER JOIN person_areas
        on person_areas.person_id = people.id
      left outer join areas
        on person_areas.area_id = areas.id
      LEFT OUTER JOIN location_areas
        on location_areas.area_id = areas.id
      LEFT OUTER JOIN locations
        on locations.id = location_areas.location_id
       left outer join areas market
	      on market.id = cast(substring(areas.ancestry from position('/' in areas.ancestry) + 1) as integer)
	     left outer join areas region
	      on region.id = cast(substring(areas.ancestry from 1 for position('/' in areas.ancestry) - 1) as integer)
EOF
  end

  def sales_rep_query
    'SELECT people.display_name as name, count(distinct vonage_sales.id) ' +
        self.sales_from_and_joins +
        'GROUP BY people.display_name ORDER BY people.display_name '
  end

  def sales_territory_query
    "SELECT areas.name, " +
        'count(distinct vonage_sales.id) ' +
        self.sales_from_and_joins +
        "GROUP BY areas.name ORDER BY areas.name "
  end

  def sales_market_query
    'SELECT market.name as name, count(distinct vonage_sales.id) ' +
        self.sales_from_and_joins +
        'GROUP BY market.name ORDER BY market.name '
  end

  def sales_region_query
    "SELECT region.name, " +
        'count(distinct vonage_sales.id) ' +
        self.sales_from_and_joins +
        "GROUP BY region.name ORDER BY region.name "
  end

  def sales_from_and_joins
    from_and_joins_string = self.send(('sales_every_from_and_join').to_sym)
    from_and_joins_string + self.send(('sales_where_clause').to_sym)
  end
end