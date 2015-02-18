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
      chart_url = "#{Rails.application.routes.url_helpers.root_url}/#{generate_chart(results)}"
    else
      chart_url = "http://localhost:3000/#{generate_chart(results)}"
    end
    messages = self.generate_messages(results)
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
        'last',
        'this',
        'week',
        'weekend',
        'month',
        'yesterday',
        'today'
    ]
  end

  def query
    if self.has_keyword?('rep')
      select = self.rep_query
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
        "rsprint_sales.date_sold >= CAST('#{self.start_date}' AS DATE) AND " +
        "rsprint_sales.date_sold <= CAST('#{self.end_date}' AS DATE) "
  end

  def rep_query
    'SELECT ad_user.name, count(rsprint_sales.rsprint_sales_id) ' +
        self.from_and_joins +
        'GROUP BY ad_user.name ORDER BY ad_user.name '
  end

  def territory_query
    'SELECT c_salesregion.name, count(rsprint_sales.rsprint_sales_id) ' +
        self.from_and_joins +
        'GROUP BY c_salesregion.name ORDER BY c_salesregion.name '
  end

  def from_and_joins
    'FROM rsprint_sales ' +
        'LEFT OUTER JOIN c_bpartner_location ' +
        'ON c_bpartner_location.c_bpartner_location_id = rsprint_sales.c_bpartner_location_id ' +
        'LEFT OUTER JOIN c_salesregion ' +
        'ON c_salesregion.c_salesregion_id = c_bpartner_location.c_salesregion_id ' +
        'LEFT OUTER JOIN ad_user ' +
        'ON ad_user.ad_user_id = rsprint_sales.ad_user_id ' +
        self.where_clause
  end
end