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
        'with'
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
    previous_database = ActiveRecord::Base.connection.current_database
    database_parts = previous_database.split('_')
    database_parts.shift if database_parts.count > 1
    connection = ActiveRecord::Base.establish_connection(:rbd_connect_production).connection
    results = connection.execute(select)
    ActiveRecord::Base.establish_connection database_parts.join('_').to_sym
    results
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