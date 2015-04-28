require 'apis/groupme'
require 'group_me_bot_query'
require_relative 'group_me_bot_sales_messages'

class ComcastGroupMeBotCallback
  include GroupMeBotQuery
  include GroupMeBotSalesMessages

  attr_accessor :query_string,
                :keywords

  def initialize(json)
    @callback = GroupMeBotCallback.new(json)
  end

  def process
    return unless @callback and @callback.group_id
    group_me_bot = ComcastGroupMeBot.find_by group_num: @callback.group_id
    return unless group_me_bot
    bot_id = group_me_bot.bot_num
    return unless bot_id
    self.separate_string
    self.determine_date_range
    sales = self.pull_sales
    @results = self.query(sales)
    check_environment #GroupMeBotQuery
    if self.has_keyword?('schedule')
      message = ['Schedule your new SalesMaker for training at http://bit.ly/1w3AGqG !']
      GroupMe.new_global.post_messages_with_bot(message, bot_id)
    else
      messages = self.generate_messages(@results)
      GroupMe.new_global.post_messages_with_bot(messages, bot_id, @chart_url)
    end
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
        'today',
        'schedule'
    ]
  end

  def pull_sales
    ComcastSale.sold_between_dates(self.start_date, self.end_date)
  end

  def query(sales)
    if self.has_keyword?('rep')
      select = self.rep_query(sales)
    else
      select = self.territory_query(sales)
    end
    connection = ActiveRecord::Base.connection
    connection.execute(select)
  end

  def where_clause(sales)
    return 'WHERE false ' if sales.count == 0
    ids = sales.map(&:id).join(',')
    "WHERE areas.name ILIKE '%#{query_string}%' AND " +
        "projects.name = 'Comcast Retail' AND " +
        "comcast_sales.id IN (#{ids}) "
  end

  def rep_query(sales)
    'SELECT people.display_name AS name, sum(' +
        'case when comcast_sales.tv = true then 1 else 0 end + ' +
        'case when comcast_sales.internet = true then 1 else 0 end + ' +
        'case when comcast_sales.phone = true then 1 else 0 end + ' +
        'case when comcast_sales.security = true then 1 else 0 end' +
        ') as count ' +
        self.from_and_joins(sales) +
        'GROUP BY people.display_name ORDER BY people.display_name '
  end

  def territory_query(sales)
    'SELECT areas.name, sum(' +
        'case when comcast_sales.tv = true then 1 else 0 end + ' +
        'case when comcast_sales.internet = true then 1 else 0 end + ' +
        'case when comcast_sales.phone = true then 1 else 0 end + ' +
        'case when comcast_sales.security = true then 1 else 0 end' +
        ') as count ' +
        self.from_and_joins(sales) +
        'GROUP BY areas.name ORDER BY areas.name '
  end

  def from_and_joins(sales)
    'FROM comcast_sales ' +
        'LEFT OUTER JOIN comcast_customers ' +
        'ON comcast_customers.id = comcast_sales.comcast_customer_id ' +
        'LEFT OUTER JOIN locations ' +
        'ON locations.id = comcast_customers.location_id ' +
        'LEFT OUTER JOIN location_areas ' +
        'ON location_areas.location_id = locations.id ' +
        'LEFT OUTER JOIN areas ' +
        'ON areas.id = location_areas.area_id ' +
        'LEFT OUTER JOIN projects ' +
        'ON projects.id = areas.project_id ' +
        'LEFT OUTER JOIN people ' +
        'ON people.id = comcast_sales.person_id ' +
        self.where_clause(sales)
  end

end