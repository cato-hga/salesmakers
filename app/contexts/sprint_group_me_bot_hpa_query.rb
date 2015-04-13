module SprintGroupMeBotHPAQuery
  protected

  def wrap_query(query)
    "SELECT name, " +
        "CASE WHEN everything.sales IS NULL OR everything.sales = 0 " +
        "THEN everything.hours ELSE everything.hours / everything.sales END " +
        "AS hpa  FROM (" + query + ") everything ORDER BY hpa ASC, name ASC "
  end

  def every_where_clause
    "r.name LIKE 'Sprint Prepaid %' AND "
  end

  def where_clause
    "WHERE r.name ILIKE '%#{query_string}%' AND " +
        every_where_clause +
        "t.shift_date >= CAST('#{self.start_date}' AS DATE) AND " +
        "t.shift_date < CAST('#{self.end_date}' AS DATE) AND " +
        "t.site_name NOT ILIKE '%training%' AND t.hours > 0.00 AND " +
        "t.site_name NOT ILIKE '%advocate%' AND " +
        "r.name LIKE 'Sprint %' "
  end

  def region_where_clause(region_name)
    "WHERE r.name ILIKE '%#{query_string}%' AND " +
        every_where_clause +
        "region.name = '#{region_name}' AND " +
        "t.shift_date >= CAST('#{self.start_date}' AS DATE) AND " +
        "t.shift_date < CAST('#{self.end_date}' AS DATE) AND " +
        "t.site_name NOT ILIKE '%training%' AND t.hours > 0.00 AND " +
        "t.site_name NOT ILIKE '%advocate%' AND " +
        "r.name LIKE 'Sprint %' "
  end

  def director_where_clause(director_name)
    "WHERE r.name ILIKE '%#{query_string}%' AND " +
        every_where_clause +
        "r.description ILIKE '#{director_name}' AND " +
        "t.shift_date >= CAST('#{self.start_date}' AS DATE) AND " +
        "t.shift_date < CAST('#{self.end_date}' AS DATE) AND " +
        "t.site_name NOT ILIKE '%training%' AND t.hours > 0.00 AND " +
        "t.site_name NOT ILIKE '%advocate%' AND " +
        "r.name LIKE 'Sprint %' "
  end

  def from_and_joins
    from_and_joins_string = 'from rsprint_timesheet t ' +
        'left outer join ad_user u ' +
        'on u.ad_user_id = t.ad_user_id ' +
        'left outer join c_bpartner_location l ' +
        'on l.c_bpartner_location_id = t.c_bpartner_location_id ' +
        'left outer join c_salesregion r ' +
        'on (r.c_salesregion_id = l.c_salesregion_id ' +
        'and l.c_salesregion_id is not null) ' +
        'or (r.salesrep_id = u.supervisor_id ' +
        "and r.value LIKE '%-4' " +
        'and l.c_salesregion_id is null) ' +
        'left outer join ad_user tl ' +
        'on tl.ad_user_id = r.salesrep_id ' +
        'left outer join ad_user asm ' +
        'on asm.ad_user_id = tl.supervisor_id ' +
        'left outer join ad_user rm ' +
        'on rm.ad_user_id = asm.supervisor_id ' +
        'left outer join c_salesregion region ' +
        'on region.salesrep_id = rm.ad_user_id ' +
        'left outer join (select ' +
        'rsprint_sales.ad_user_id as ad_user_id, ' +
        'count(rsprint_sales_id) as sales ' +
        'from rsprint_sales ' +
        'where ' +
        "rsprint_sales.date_sold >= cast('#{self.start_date}' as timestamp) AND " +
        "rsprint_sales.date_sold < cast('#{self.end_date}' as timestamp) AND " +
        "rsprint_sales.activated_in_store = 'Yes' " +
        'group by ad_user_id ' +
        'order by ad_user_id) sales ' +
        'on sales.ad_user_id = u.ad_user_id '
    if self.has_keyword?('red')
      from_and_joins_string += self.region_where_clause('Sprint Red Region')
    elsif self.has_keyword?('blue')
      from_and_joins_string += self.region_where_clause('Sprint Blue Region')
    elsif self.has_keyword?('bland')
      from_and_joins_string += self.director_where_clause('bland')
    elsif self.has_keyword?('moulison')
      from_and_joins_string += self.director_where_clause('moulison')
    elsif self.has_keyword?('miller')
      from_and_joins_string += self.director_where_clause('miller')
    elsif self.has_keyword?('willison')
      from_and_joins_string += self.director_where_clause('willison')
    else
      from_and_joins_string += self.where_clause
    end
    from_and_joins_string
  end

  def rep_query
    'SELECT u.name, sum(t.hours) as hours, sales.sales ' +
        self.from_and_joins +
        'GROUP BY u.name, sales.sales ORDER BY u.name, sales.sales '
  end

  def territory_query
    "SELECT name, sum(hours) as hours, sum(sales) as sales FROM ( " +
        "SELECT replace(replace(r.name, ' Territory', ''), 'Sprint Prepaid - ', '') as name, " +
        'sum(t.hours) as hours, sales.sales ' +
        self.from_and_joins +
        "GROUP BY replace(replace(r.name, ' Territory', ''), 'Sprint Prepaid - ', ''), sales.sales ORDER BY replace(replace(r.name, ' Territory', ''), 'Sprint Prepaid - ', ''), sales.sales ) all_of_it " +
        "GROUP BY name ORDER BY name "
  end

  def region_query
    "SELECT name, sum(hours) as hours, sum(sales) as sales FROM ( " +
        'SELECT region.name, ' +
        'sum(t.hours) as hours, sales.sales ' +
        self.from_and_joins +
        'GROUP BY region.name, sales.sales ORDER BY region.name, sales.sales ) all_of_it ' +
        "GROUP BY name ORDER BY name "
  end

  def director_query
    "SELECT name, sum(hours) as hours, sum(sales) as sales FROM ( " +
        'SELECT initcap(r.description) AS name, ' +
        'sum(t.hours) as hours, sales.sales ' +
        self.from_and_joins +
        'GROUP BY initcap(r.description), sales.sales ORDER BY initcap(r.description), sales.sales ) all_of_it ' +
        "GROUP BY name ORDER BY name "
  end

  def generate_messages(results)
    return [] unless results and results.count > 0
    char_count = 0
    result_strings = []
    result_string = ''
    total = 0
    message_count = 0
    for result in results do
      message_count += 1
      single_result = "[##{message_count.to_s}] #{result['name']}: #{result['hpa'].to_f.round(2).to_s}\n"
      total += result['hpa'].to_f.round(2)
      if result_string.length + single_result.length > 390
        result_strings << result_string; result_string = single_result
      else
        result_string += single_result
      end
    end
    average = total / message_count
    result_string += "\n***AVERAGE: #{average.round(2)}"
    result_strings << result_string
    result_strings
  end
end