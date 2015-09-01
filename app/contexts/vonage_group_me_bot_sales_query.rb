module VonageGroupMeBotSalesQuery
  protected

  def sales_wrap_query(query)
    "SELECT * FROM (" + query + ") everything ORDER BY everything.count DESC"
  end

  def sales_where_clause
    "WHERE areas.name ILIKE '%#{query_string}%' AND areas.name LIKE 'Vonage%' AND " +
        "vonage_sales.sale_date >= CAST('#{self.start_date}' AS DATE) AND " +
        "vonage_sales.sale_date < CAST('#{self.end_date}' AS DATE) "
  end


  def sales_every_from_and_join
    "FROM vonage_sales
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
        ON ad_user.ad_user_id = rsprint_sales.ad_user_id"
  end

  def sales_rep_query
    'SELECT personr.name, count(vonage_sales.id) ' +
        self.sales_from_and_joins +
        'GROUP BY person.name ORDER BY person.name '
  end

#   def sales_territory_query
#     "SELECT replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint Prepaid - ', '') as name, " +
#         'count(rsprint_sales.rsprint_sales_id) ' +
#         self.sales_from_and_joins +
#         "GROUP BY replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint Prepaid - ', '') ORDER BY replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint Prepaid - ', '') "
#   end
#
#   def sales_market_query
#     'SELECT ad_user.name, count(rsprint_sales.rsprint_sales_id) ' +
#         self.sales_from_and_joins +
#         'GROUP BY ad_user.name ORDER BY ad_user.name '
#   end
#
#   def sales_region_query
#     "SELECT replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint Prepaid - ', '') as name, " +
#         'count(rsprint_sales.rsprint_sales_id) ' +
#         self.sales_from_and_joins +
#         "GROUP BY replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint Prepaid - ', '') ORDER BY replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint Prepaid - ', '') "
#   end
#
#   def sales_director_query
#     'SELECT initcap(c_salesregion.description) AS name, count(rsprint_sales.rsprint_sales_id) ' +
#         self.sales_from_and_joins +
#         'GROUP BY initcap(c_salesregion.description) ORDER BY initcap(c_salesregion.description) '
#   end
#
#   def sales_brand_query
#     "SELECT rsprint_sales.carrier as name, " +
#         'count(rsprint_sales.rsprint_sales_id) ' +
#         self.sales_from_and_joins +
#         "GROUP BY rsprint_sales.carrier ORDER BY rsprint_sales.carrier "
#   end
end