module SprintGroupMeBotSalesQuery
  protected

  def sales_wrap_query(query)
    "SELECT * FROM (" + query + ") everything ORDER BY everything.count DESC"
  end

  def sales_every_where_clause
    "c_salesregion.name LIKE 'Sprint Prepaid %' AND "
  end

  def sales_where_clause
    "WHERE c_salesregion.name ILIKE '%#{query_string}%' AND " +
        sales_every_where_clause +
        sales_activations_clause +
        sales_upgrades_clause +
        "rsprint_sales.date_sold >= CAST('#{self.start_date}' AS DATE) AND " +
        "rsprint_sales.date_sold < CAST('#{self.end_date}' AS DATE) "
  end

  def sales_parameter_where_clause(parameter_name, parameter_value)
    output = ""
    case @level
      when "territory"
        output += "WHERE c_salesregion.name ILIKE '%#{query_string}%' AND "
      when "market"
        if self.has_keyword?('east')
          output += "WHERE market.name ILIKE '%east market #{query_string}%' AND "
        else
          output += "WHERE market.name ILIKE '%west market #{query_string}%' AND "
        end
      when "region"
        if self.has_keyword?('east')
          output += "WHERE region.name ILIKE '%east region%' AND "
        else
          output += "WHERE region.name ILIKE '%west region%' AND "
        end
    end
    output += sales_every_where_clause +
        sales_activations_clause +
        sales_upgrades_clause +
        "#{parameter_name} = '#{parameter_value}' AND " +
        "rsprint_sales.date_sold >= CAST('#{self.start_date}' AS DATE) AND " +
        "rsprint_sales.date_sold < CAST('#{self.end_date}' AS DATE) "
  end

  def sales_activations_clause
    return '' unless self.has_keyword?('activations')
    "rsprint_sales.activated_in_store = 'Yes' AND "
  end

  def sales_upgrades_clause
    return '' unless self.has_keyword?('upgrades')
    negate = self.has_keyword?('no') ? '!' : ''
    "rsprint_sales.upgrade #{negate}= 'Y' AND "
  end

  def sales_every_from_and_join
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
        LEFT OUTER JOIN c_salesregion market
        ON market.salesrep_id = asm.ad_user_id
        LEFT OUTER JOIN ad_user rm 
        ON rm.ad_user_id = asm.supervisor_id 
        LEFT OUTER JOIN c_salesregion region 
        ON region.salesrep_id = rm.ad_user_id 
        LEFT OUTER JOIN ad_user 
        ON ad_user.ad_user_id = rsprint_sales.ad_user_id 
EOF
  end

  def sales_rep_query
    'SELECT ad_user.name, count(rsprint_sales.rsprint_sales_id) ' +
        self.sales_from_and_joins +
        'GROUP BY ad_user.name ORDER BY ad_user.name '
  end

  def sales_territory_query
    "SELECT replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint Prepaid - ', '') as name, " +
        'count(rsprint_sales.rsprint_sales_id) ' +
        self.sales_from_and_joins +
        "GROUP BY replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint Prepaid - ', '') ORDER BY replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint Prepaid - ', '') "
  end

  def sales_market_query
    'SELECT ad_user.name, count(rsprint_sales.rsprint_sales_id) ' +
        self.sales_from_and_joins +
        'GROUP BY ad_user.name ORDER BY ad_user.name '
  end

  def sales_region_query
    "SELECT replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint Prepaid - ', '') as name, " +
        'count(rsprint_sales.rsprint_sales_id) ' +
        self.sales_from_and_joins +
        "GROUP BY replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint Prepaid - ', '') ORDER BY replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint Prepaid - ', '') "
  end

  def sales_director_query
    'SELECT initcap(c_salesregion.description) AS name, count(rsprint_sales.rsprint_sales_id) ' +
        self.sales_from_and_joins +
        'GROUP BY initcap(c_salesregion.description) ORDER BY initcap(c_salesregion.description) '
  end

  def sales_brand_query
    "SELECT rsprint_sales.carrier as name, " +
        'count(rsprint_sales.rsprint_sales_id) ' +
        self.sales_from_and_joins +
        "GROUP BY rsprint_sales.carrier ORDER BY rsprint_sales.carrier "
  end
end