module SprintGroupMeBotHPAQuery
  protected

  def hpa_wrap_query(query)
    "SELECT name, " +
        "CASE WHEN everything.sales IS NULL OR everything.sales = 0 " +
        "THEN everything.hours ELSE everything.hours / everything.sales END " +
        "AS hpa  FROM (" + query + ") everything ORDER BY hpa ASC, name ASC "
  end

  def hpa_every_where_clause
    "r.name LIKE 'Sprint Prepaid %' AND "
  end

  def hpa_where_clause
    "WHERE r.name ILIKE '%#{query_string}%' AND " +
        hpa_every_where_clause +
        "t.shift_date >= CAST('#{self.start_date}' AS DATE) AND " +
        "t.shift_date < CAST('#{self.end_date}' AS DATE) AND " +
        "t.site_name NOT ILIKE '%training%' AND t.hours > 0.00 AND " +
        "t.site_name NOT ILIKE '%advocate%' AND " +
        "r.name LIKE 'Sprint %' "
  end

  def hpa_parameter_where_clause(parameter_name, parameter_value)
    "WHERE r.name ILIKE '%#{query_string}%' AND " +
        hpa_every_where_clause +
        "#{parameter_name} = '#{parameter_value}' AND " +
        "t.shift_date >= CAST('#{self.start_date}' AS DATE) AND " +
        "t.shift_date < CAST('#{self.end_date}' AS DATE) AND " +
        "t.site_name NOT ILIKE '%training%' AND t.hours > 0.00 AND " +
        "t.site_name NOT ILIKE '%advocate%' AND " +
        "r.name LIKE 'Sprint %' "
  end

  def hpa_every_from_and_join
    <<EOF
        from rsprint_timesheet t 
        left outer join ad_user u 
        on u.ad_user_id = t.ad_user_id 
        left outer join c_bpartner_location l 
        on l.c_bpartner_location_id = t.c_bpartner_location_id 
        left outer join c_salesregion r 
        on (r.c_salesregion_id = l.c_salesregion_id 
        and l.c_salesregion_id is not null) 
        or (r.salesrep_id = u.supervisor_id 
        and r.value LIKE '%-4'
        and l.c_salesregion_id is null) 
        left outer join ad_user tl 
        on tl.ad_user_id = r.salesrep_id 
        left outer join ad_user asm 
        on asm.ad_user_id = tl.supervisor_id 
        left outer join ad_user rm 
        on rm.ad_user_id = asm.supervisor_id 
        left outer join c_salesregion region 
        on region.salesrep_id = rm.ad_user_id 
        left outer join (select 
        rsprint_sales.ad_user_id as ad_user_id, 
        count(rsprint_sales_id) as sales 
        from rsprint_sales 
        where 
        rsprint_sales.date_sold >= cast('#{self.start_date}' as timestamp) AND 
        rsprint_sales.date_sold < cast('#{self.end_date}' as timestamp) AND 
        rsprint_sales.activated_in_store = 'Yes' 
        group by ad_user_id 
        order by ad_user_id) sales 
        on sales.ad_user_id = u.ad_user_id 
EOF
  end

  def hpa_rep_query
    'SELECT u.name, sum(t.hours) as hours, sales.sales ' +
        self.hpa_from_and_joins +
        'GROUP BY u.name, sales.sales ORDER BY u.name, sales.sales '
  end

  def hpa_territory_query
    "SELECT name, sum(hours) as hours, sum(sales) as sales FROM ( " +
        "SELECT replace(replace(r.name, ' Territory', ''), 'Sprint Prepaid - ', '') as name, " +
        'sum(t.hours) as hours, sales.sales ' +
        self.hpa_from_and_joins +
        "GROUP BY replace(replace(r.name, ' Territory', ''), 'Sprint Prepaid - ', ''), sales.sales ORDER BY replace(replace(r.name, ' Territory', ''), 'Sprint Prepaid - ', ''), sales.sales ) all_of_it " +
        "GROUP BY name ORDER BY name "
  end

  def hpa_region_query
    "SELECT name, sum(hours) as hours, sum(sales) as sales FROM ( " +
        'SELECT region.name, ' +
        'sum(t.hours) as hours, sales.sales ' +
        self.hpa_from_and_joins +
        'GROUP BY region.name, sales.sales ORDER BY region.name, sales.sales ) all_of_it ' +
        "GROUP BY name ORDER BY name "
  end

  def hpa_director_query
    "SELECT name, sum(hours) as hours, sum(sales) as sales FROM ( " +
        'SELECT initcap(r.description) AS name, ' +
        'sum(t.hours) as hours, sales.sales ' +
        self.hpa_from_and_joins +
        'GROUP BY initcap(r.description), sales.sales ORDER BY initcap(r.description), sales.sales ) all_of_it ' +
        "GROUP BY name ORDER BY name "
  end

  def hpa_generate_messages(results)
    return [] unless results and results.count > 0
    char_count = 0
    hpa_strings = []
    hpa_string = ''
    total = 0
    message_count = 0
    for result in results do
      message_count += 1
      hpa_result = "[##{message_count.to_s}] #{result['name']}: #{result['hpa'].to_f.round(2).to_s}\n"
      total += result['hpa'].to_f.round(2)
      if hpa_string.length + hpa_result.length > 390
        hpa_strings << hpa_string; hpa_string = hpa_result
      else
        hpa_string += hpa_result
      end
    end
    average = total / message_count
    hpa_string += "\n***AVERAGE: #{average.round(2)}"
    hpa_strings << hpa_string
    hpa_strings
  end
end