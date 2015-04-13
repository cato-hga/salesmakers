module SprintGroupMeBotSalesQuery
  protected

  def wrap_query(query)
    "SELECT * FROM (" + query + ") everything ORDER BY everything.count DESC"
  end

  def every_where_clause
    "c_salesregion.name LIKE 'Sprint Prepaid %' AND "
  end

  def where_clause
    "WHERE c_salesregion.name ILIKE '%#{query_string}%' AND " +
        every_where_clause +
        activations_clause +
        upgrades_clause +
        "rsprint_sales.date_sold >= CAST('#{self.start_date}' AS DATE) AND " +
        "rsprint_sales.date_sold < CAST('#{self.end_date}' AS DATE) "
  end

  def parameter_where_clause(parameter_name, parameter_value)
    "WHERE c_salesregion.name ILIKE '%#{query_string}%' AND " +
        every_where_clause +
        activations_clause +
        upgrades_clause +
        "#{parameter_name} = '#{parameter_value}' AND " +
        "rsprint_sales.date_sold >= CAST('#{self.start_date}' AS DATE) AND " +
        "rsprint_sales.date_sold < CAST('#{self.end_date}' AS DATE) "
  end

  def activations_clause
    return '' unless self.has_keyword?('activations')
    "rsprint_sales.activated_in_store = 'Yes' AND "
  end

  def upgrades_clause
    return '' unless self.has_keyword?('upgrades')
    negate = self.has_keyword?('no') ? '!' : ''
    "rsprint_sales.upgrade #{negate}= 'Y' AND "
  end

  def every_from_and_join
    <<EOF
        FROM rsprint_sales 
        LEFT OUTER JOIN c_bpartner_location 
        ON c_bpartner_location.c_bpartner_location_id = rsprint_sales.c_bpartner_location_id 
        LEFT OUTER JOIN c_salesregion 
        ON c_salesregion.c_salesregion_id = c_bpartner_location.c_salesregion_id 
        LEFT OUTER JOIN ad_user tl 
        ON tl.ad_user_id = c_salesregion.salesrep_id 
        LEFT OUTER JOIN ad_user asm 
        ON asm.ad_user_id = tl.supervisor_id 
        LEFT OUTER JOIN ad_user rm 
        ON rm.ad_user_id = asm.supervisor_id 
        LEFT OUTER JOIN c_salesregion region 
        ON region.salesrep_id = rm.ad_user_id 
        LEFT OUTER JOIN ad_user 
        ON ad_user.ad_user_id = rsprint_sales.ad_user_id 
EOF
  end

  def rep_query
    'SELECT ad_user.name, count(rsprint_sales.rsprint_sales_id) ' +
        self.from_and_joins +
        'GROUP BY ad_user.name ORDER BY ad_user.name '
  end

  def territory_query
    "SELECT replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint Prepaid - ', '') as name, " +
        'count(rsprint_sales.rsprint_sales_id) ' +
        self.from_and_joins +
        "GROUP BY replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint Prepaid - ', '') ORDER BY replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint Prepaid - ', '') "
  end

  def region_query
    'SELECT region.name, count(rsprint_sales.rsprint_sales_id) ' +
        self.from_and_joins +
        'GROUP BY region.name ORDER BY region.name '
  end

  def director_query
    'SELECT initcap(c_salesregion.description) AS name, count(rsprint_sales.rsprint_sales_id) ' +
        self.from_and_joins +
        'GROUP BY initcap(c_salesregion.description) ORDER BY initcap(c_salesregion.description) '
  end

  def brand_query
    "SELECT rsprint_sales.carrier as name, " +
        'count(rsprint_sales.rsprint_sales_id) ' +
        self.from_and_joins +
        "GROUP BY rsprint_sales.carrier ORDER BY rsprint_sales.carrier "
  end
end