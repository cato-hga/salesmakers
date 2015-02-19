require 'apis/groupme'
require 'group_me_bot_sales_query'

class SprintGroupMeBotCallback
  include GroupMeBotSalesQuery

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
      self.sales_messages(bot_id)
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

  def sales_messages(bot_id)
    self.determine_date_range
    results = self.query
    if Rails.env.production? or Rails.env == 'staging'
      chart_url = "#{Rails.application.routes.url_helpers.root_url}#{generate_chart(results)}"
    else
      chart_url = "http://localhost:3000/#{generate_chart(results)}"
    end
    messages = self.generate_messages(results)
    if messages.empty?
      messages << "No results for '#{query_string}'"
      chart_url = nil
    end
    GroupMe.new_global.post_messages_with_bot(messages, bot_id, chart_url)
  end

  def separate_string
    self.keywords = Array.new
    self.query_string = Array.new
    for word in @callback.text.split do
      word.strip!; word.gsub!(/[^A-Za-z0-9 ]/, '')
      if keyword_list.include?(word)
        self.keywords << word
      else
        self.query_string << word
      end
    end
    self.query_string = self.query_string.join(' ').strip
  end

  protected

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
        'training'
    ]
  end

  def query
    if self.has_keyword?('rep')
      select = self.rep_query
    elsif self.has_keyword?('brand')
      select = self.brand_query
    elsif self.has_keyword?('region')
      select = self.region_query
    elsif self.has_keyword?('director')
      select = self.director_query
    else
      select = self.territory_query
    end
    select = wrap_query(select)
    previous_database = ActiveRecord::Base.connection.current_database
    database_parts = previous_database.split('_')
    database_parts.shift if database_parts.count > 1
    connection = ActiveRecord::Base.establish_connection(:rbd_connect_production).connection
    results = connection.execute(select)
    ActiveRecord::Base.establish_connection database_parts.join('_').to_sym
    results
  end

  def wrap_query(query)
    "SELECT * FROM (" + query + ") everything ORDER BY everything.count DESC"
  end

  def where_clause
    "WHERE c_salesregion.name ILIKE '%#{query_string}%' AND " +
        activations_clause +
        upgrades_clause +
        "rsprint_sales.date_sold >= CAST('#{self.start_date}' AS DATE) AND " +
        "rsprint_sales.date_sold <= CAST('#{self.end_date}' AS DATE) "
  end

  def region_where_clause(region_name)
    "WHERE c_salesregion.name ILIKE '%#{query_string}%' AND " +
        activations_clause +
        upgrades_clause +
        "region.name = '#{region_name}' AND " +
        "rsprint_sales.date_sold >= CAST('#{self.start_date}' AS DATE) AND " +
        "rsprint_sales.date_sold <= CAST('#{self.end_date}' AS DATE) "
  end

  def director_where_clause(director_name)
    "WHERE c_salesregion.name ILIKE '%#{query_string}%' AND " +
        activations_clause +
        upgrades_clause +
        "c_salesregion.description ILIKE '#{director_name}' AND " +
        "rsprint_sales.date_sold >= CAST('#{self.start_date}' AS DATE) AND " +
        "rsprint_sales.date_sold <= CAST('#{self.end_date}' AS DATE) "
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

  def rep_query
    'SELECT ad_user.name, count(rsprint_sales.rsprint_sales_id) ' +
        self.from_and_joins +
        'GROUP BY ad_user.name ORDER BY ad_user.name '
  end

  def territory_query
    "SELECT replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint - ', '') as name, " +
        'count(rsprint_sales.rsprint_sales_id) ' +
        self.from_and_joins +
        "GROUP BY replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint - ', '') ORDER BY replace(replace(c_salesregion.name, ' Territory', ''), 'Sprint - ', '') "
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

  def from_and_joins
    from_and_joins_string = 'FROM rsprint_sales ' +
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
end