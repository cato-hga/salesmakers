require 'apis/groupme'
require 'group_me_bot_query'

class SprintGroupMeBotCallback
  include GroupMeBotQuery

  attr_accessor :query_string,
                :keywords

  def initialize(json)
    @callback = GroupMeBotCallback.new(json)
  end

  def process
    return unless @callback and @callback.group_id
    group_me_bot = SprintGroupMeBot.find_by group_num: @callback.group_id
    return unless group_me_bot
    bot_id = group_me_bot.bot_num
    return unless bot_id
    self.separate_string
    if self.has_keyword?('help')
      self.help_messages(bot_id)
    elsif self.has_keyword?('s')
      message = ['Enter sales at http://sprint.rbdconnect.com/']
      GroupMe.new_global.post_messages_with_bot(message, bot_id)
    elsif self.has_keyword?('referral')
      message = ['Refer our next superstar by visiting http://goo.gl/forms/hwljCSx9gr']
      GroupMe.new_global.post_messages_with_bot(message, bot_id)
    elsif self.has_keyword?('schedule')
      message = ['Schedule your new SalesMaker for training at http://goo.gl/zH8cOi !']
      GroupMe.new_global.post_messages_with_bot(message, bot_id)
    elsif self.has_keyword?('training')
      message = ['https://docs.google.com/a/retaildoneright.com/forms/d/1QP2zs_r_wO77eOYBYVinpGBvIcY0931T3SBapjZYXmE/viewform']
      GroupMe.new_global.post_messages_with_bot(message, bot_id)
    else
      self.sales_and_hpa_messages(bot_id)
    end
  end

  def help_messages(bot_id)
    messages = []
    messages << "When addressing the bot, use an exclamation point ('!') at " +
        "the beginning of your message. Each command consists of at least a date " +
        "range and a grouping"
    messages << "====== Date Range ======\r\n" +
        "If you don't specify a range, the bot will assume you want to see " +
        "today only. If you want to see a different date range, the following " +
        "options are available to you:"
    messages << "* 'yesterday'\r\n" +
        "* 'last week' or 'this week' (Monday-Sunday)\r\n" +
        "* 'last month' or 'this month'\r\n" +
        "* 'mtd' (month to date, same as 'this month')\r\n" +
        "* 'last weekend', or 'this weekend' (Friday-Sunday)\r\n" +
        "* 'tomorrow' (just kidding! ;)"
    messages << "====== Grouping ======\r\n" +
        "The bot will output territories by default if you don't specify that " +
        "you'd rather see information grouped by the following:"
    messages << "* 'rep'\r\n" +
        "* 'territory' (this is the default)\r\n" +
        "* 'region' (Red/Blue)\r\n" +
        "* 'brand' (carrier/provider)\r\n" +
        "* 'sprint director' (the Sprint corporate directors)"
    messages << "====== Extra Constraints ======\r\n" +
        "In addition to the default of showing all self-reported sales, you can " +
        "also add the following keywords to further filter the sales:"
    messages << "* 'upgrades' (show upgrades ONLY)\r\n" +
        "* 'no upgrades' (exclude upgrades)\r\n" +
        "* 'activations' (show sales where the rep chose 'Yes' on 'Activated in store')\r\n" +
        "* Enter the name or partial name of a territory to show only that territory's sales"
    messages << "You can also enter the name of a Sprint corporate director to " +
        "see only that director's sales.\r\nNote that any combination of of these " +
        "constriants may be used (you are not restricted to one at a time)."
    messages << "Some examples to try:\r\n" +
        "* '!mtd activations and no upgrades'\r\n" +
        "* '!last week by brand'\r\n" +
        "* '!last month upgrades'\r\n" +
        "* '!this week philadelphia by rep with activations and no upgrades'"
    GroupMe.new_global.post_messages_with_bot(messages, bot_id)
  end

  def sales_and_hpa_messages(bot_id)
    level_keywords = ['rep', 'brand', 'region', 'director', 'territory']
    level_keywords.each do |key|
      if self.has_keyword? key
        @level = key and return
      end
    end
    self.determine_date_range
    generate_message_content
    GroupMe.new_global.post_messages_with_bot(@messages, bot_id, @chart_url)
  end

  def generate_message_content
    if self.has_keyword? 'sales'
      @results = self.query(@level, 'sales')
      check_environment
      @messages = self.generate_sales_messages(@results)
    end
    if self.has_keyword? 'hpa'
      @results = self.query(@level, 'hpa')
      @messages = self.generate_sales_messages(@results)
    end
    if messages.empty?
      @messages << "No results for '#{query_string}'"
      @chart_url = nil
    end
  end
  protected

  def query(level, type)
    select = self.send(level + '_' + type + '_query')
    select = self.send('wrap_'+ type + '_query', (select))
    begin
      tries ||= 3
      connection = ConnectDatabaseConnection.establish_connection(:rbd_connect_production).connection
      sleep 0.1
      results = connection.execute(select)
    rescue ActiveRecord::StatementInvalid, PG::ConnectionBad
      sleep 0.1
      retry unless (tries -= 1).zero?
    end
    results
  end

  def keyword_list
    [
        'help',
        'mtd',
        'sales',
        'by',
        'rep',
        'territory',
        'region',
        'brand',
        'last',
        'this',
        'week',
        'weekend',
        'month',
        'yesterday',
        'today',
        'red',
        'blue',
        'bland',
        'moulison',
        'miller',
        'willison',
        'sprint',
        'director',
        'no',
        'upgrades',
        'activations',
        'and',
        'with',
        's',
        'referral',
        'schedule',
        'training',
        'hpa'
    ]
  end


  def wrap_sales_query(query)
    "SELECT * FROM (" + query + ") everything ORDER BY everything.count DESC"
  end

  def sales_where_clause
    "WHERE c_salesregion.name ILIKE '%#{query_string}%' AND " +
        activations_sales_clause +
        upgrades_sales_clause +
        "rsprint_sales.date_sold >= CAST('#{self.start_date}' AS DATE) AND " +
        "rsprint_sales.date_sold < CAST('#{self.end_date}' AS DATE) "
  end

  def region_sales_where_clause(region_name)
    "WHERE c_salesregion.name ILIKE '%#{query_string}%' AND " +
        activations_sales_clause +
        upgrades_sales_clause +
        "region.name = '#{region_name}' AND " +
        "rsprint_sales.date_sold >= CAST('#{self.start_date}' AS DATE) AND " +
        "rsprint_sales.date_sold < CAST('#{self.end_date}' AS DATE) "
  end

  def director_sales_where_clause(director_name)
    "WHERE c_salesregion.name ILIKE '%#{query_string}%' AND " +
        activations_sales_clause +
        upgrades_sales_clause +
        "c_salesregion.description ILIKE '#{director_name}' AND " +
        "rsprint_sales.date_sold >= CAST('#{self.start_date}' AS DATE) AND " +
        "rsprint_sales.date_sold < CAST('#{self.end_date}' AS DATE) "
  end

  def activations_sales_clause
    return '' unless self.has_keyword?('activations')
    "rsprint_sales.activated_in_store = 'Yes' AND "
  end

  def upgrades_sales_clause
    return '' unless self.has_keyword?('upgrades')
    negate = self.has_keyword?('no') ? '!' : ''
    "rsprint_sales.upgrade #{negate}= 'Y' AND "
  end

  def rep_sales_query
    'SELECT ad_user.name, count(rsprint_sales.rsprint_sales_id) ' +
        self.sales_from_and_joins +
        'GROUP BY ad_user.name ORDER BY ad_user.name '
  end

  def territory_sales_query
    "SELECT replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint - ', '') as name, " +
        'count(rsprint_sales.rsprint_sales_id) ' +
        self.sales_from_and_joins +
        "GROUP BY replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint - ', '') ORDER BY replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint - ', '') "
  end

  def region_sales_query
    'SELECT region.name, count(rsprint_sales.rsprint_sales_id) ' +
        self.sales_from_and_joins +
        'GROUP BY region.name ORDER BY region.name '
  end

  def director_sales_query
    'SELECT initcap(c_salesregion.description) AS name, count(rsprint_sales.rsprint_sales_id) ' +
        self.sales_from_and_joins +
        'GROUP BY initcap(c_salesregion.description) ORDER BY initcap(c_salesregion.description) '
  end

  def brand_sales_query
    "SELECT rsprint_sales.carrier as name, " +
        'count(rsprint_sales.rsprint_sales_id) ' +
        self.sales_from_and_joins +
        "GROUP BY rsprint_sales.carrier ORDER BY rsprint_sales.carrier "
  end

  def sales_from_and_joins
    sales_from_and_joins_string = 'FROM rsprint_sales ' +
        'LEFT OUTER JOIN c_bpartner_location ' +
        'ON c_bpartner_location.c_bpartner_location_id = rsprint_sales.c_bpartner_location_id ' +
        'LEFT OUTER JOIN c_salesregion ' +
        'ON c_salesregion.c_salesregion_id = c_bpartner_location.c_salesregion_id ' +
        'LEFT OUTER JOIN ad_user tl ' +
        'ON tl.ad_user_id = c_salesregion.salesrep_id ' +
        'LEFT OUTER JOIN ad_user asm ' +
        'ON asm.ad_user_id = tl.supervisor_id ' +
        'LEFT OUTER JOIN ad_user rm ' +
        'ON rm.ad_user_id = asm.supervisor_id ' +
        'LEFT OUTER JOIN c_salesregion region ' +
        'ON region.salesrep_id = rm.ad_user_id ' +
        'LEFT OUTER JOIN ad_user ' +
        'ON ad_user.ad_user_id = rsprint_sales.ad_user_id '
    if self.has_keyword?('red')
      sales_from_and_joins_string += self.region_sales_where_clause('Sprint Red Region')
    elsif self.has_keyword?('blue')
      sales_from_and_joins_string += self.region_sales_where_clause('Sprint Blue Region')
    elsif self.has_keyword?('bland')
      sales_from_and_joins_string += self.director_sales_where_clause('bland')
    elsif self.has_keyword?('moulison')
      sales_from_and_joins_string += self.director_sales_where_clause('moulison')
    elsif self.has_keyword?('miller')
      sales_from_and_joins_string += self.director_sales_where_clause('miller')
    elsif self.has_keyword?('willison')
      sales_from_and_joins_string += self.director_sales_where_clause('willison')
    else
      sales_from_and_joins_string += self.sales_where_clause
    end
    sales_from_and_joins_string
  end

  #----------HPA------------

  def wrap_hpa_query(query)
    "SELECT name, " +
        "CASE WHEN everything.sales IS NULL OR everything.sales = 0 " +
        "THEN everything.hours ELSE everything.hours / everything.sales END " +
        "AS hpa  FROM (" + query + ") everything ORDER BY hpa ASC, name ASC "
  end

  def hpa_where_clause
    "WHERE r.name ILIKE '%#{query_string}%' AND " +
        "t.shift_date >= CAST('#{self.start_date}' AS DATE) AND " +
        "t.shift_date < CAST('#{self.end_date}' AS DATE) AND " +
        "t.site_name NOT ILIKE '%training%' AND t.hours > 0.00 AND " +
        "t.site_name NOT ILIKE '%advocate%' AND " +
        "r.name LIKE 'Sprint %' "
  end

  def region_hpa_where_clause(region_name)
    "WHERE r.name ILIKE '%#{query_string}%' AND " +
        "region.name = '#{region_name}' AND " +
        "t.shift_date >= CAST('#{self.start_date}' AS DATE) AND " +
        "t.shift_date < CAST('#{self.end_date}' AS DATE) AND " +
        "t.site_name NOT ILIKE '%training%' AND t.hours > 0.00 AND " +
        "t.site_name NOT ILIKE '%advocate%' AND " +
        "r.name LIKE 'Sprint %' "
  end

  def director_hpa_where_clause(director_name)
    "WHERE r.name ILIKE '%#{query_string}%' AND " +
        "r.description ILIKE '#{director_name}' AND " +
        "t.shift_date >= CAST('#{self.start_date}' AS DATE) AND " +
        "t.shift_date < CAST('#{self.end_date}' AS DATE) AND " +
        "t.site_name NOT ILIKE '%training%' AND t.hours > 0.00 AND " +
        "t.site_name NOT ILIKE '%advocate%' AND " +
        "r.name LIKE 'Sprint %' "
  end

  def rep_hpa_query
    'SELECT u.name, sum(t.hours) as hours, sales.sales ' +
        self.hpa_from_and_joins +
        'GROUP BY u.name, sales.sales ORDER BY u.name, sales.sales '
  end

  def territory_hpa_query
    "SELECT name, sum(hours) as hours, sum(sales) as sales FROM ( " +
        "SELECT replace(replace(r.name, ' Territory', ''), 'Sprint - ', '') as name, " +
        'sum(t.hours) as hours, sales.sales ' +
        self.hpa_from_and_joins +
        "GROUP BY replace(replace(r.name, ' Territory', ''), 'Sprint - ', ''), sales.sales ORDER BY replace(replace(r.name, ' Territory', ''), 'Sprint - ', ''), sales.sales ) all_of_it " +
        "GROUP BY name ORDER BY name "
  end

  def region_hpa_query
    "SELECT name, sum(hours) as hours, sum(sales) as sales FROM ( " +
        'SELECT region.name, ' +
        'sum(t.hours) as hours, sales.sales ' +
        self.hpa_from_and_joins +
        'GROUP BY region.name, sales.sales ORDER BY region.name, sales.sales ) all_of_it ' +
        "GROUP BY name ORDER BY name "
  end

  def director_hpa_query
    "SELECT name, sum(hours) as hours, sum(sales) as sales FROM ( " +
        'SELECT initcap(r.description) AS name, ' +
        'sum(t.hours) as hours, sales.sales ' +
        self.hpa_from_and_joins +
        'GROUP BY initcap(r.description), sales.sales ORDER BY initcap(r.description), sales.sales ) all_of_it ' +
        "GROUP BY name ORDER BY name "
  end

  def hpa_from_and_joins
    hpa_from_and_joins_string = 'from rsprint_timesheet t ' +
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
      hpa_from_and_joins_string += self.region_hpa_where_clause('Sprint Red Region')
    elsif self.has_keyword?('blue')
      hpa_from_and_joins_string += self.region_hpa_where_clause('Sprint Blue Region')
    elsif self.has_keyword?('bland')
      hpa_from_and_joins_string += self.director_hpa_where_clause('bland')
    elsif self.has_keyword?('moulison')
      hpa_from_and_joins_string += self.director_hpa_where_clause('moulison')
    elsif self.has_keyword?('miller')
      hpa_from_and_joins_string += self.director_hpa_where_clause('miller')
    elsif self.has_keyword?('willison')
      hpa_from_and_joins_string += self.director_hpa_where_clause('willison')
    else
      hpa_from_and_joins_string += self.hpa_where_clause
    end
    hpa_from_and_joins_string
  end
end