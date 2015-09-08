require 'apis/groupme'
require 'group_me_bot_query'
require_relative 'sprint_group_me_bot_query'
require_relative 'group_me_bot_sales_messages'
require_relative 'sprint_group_me_bot_help'
require_relative 'sprint_group_me_bot_sales_query'
require_relative 'sprint_group_me_bot_hpa_query'

class SprintGroupMeBotCallback < SprintGroupMeBotQuery
  include GroupMeBotQuery
  include SprintGroupMeBotHelp
  include SprintGroupMeBotHPAQuery
  include GroupMeBotSalesMessages
  include SprintGroupMeBotSalesQuery

  attr_accessor :query_string,
                :keywords

  attr_reader :bot_id

  def initialize(json)
    @callback = GroupMeBotCallback.new(json)
  end

  def process
    return unless @callback and @callback.group_id
    group_me_bot = SprintGroupMeBot.find_by group_num: @callback.group_id
    return unless group_me_bot
    @bot_id = group_me_bot.bot_num
    return unless bot_id
    self.separate_string
    handle_command
  end

  def handle_command
    if self.has_keyword?('help')
      GroupMe.new_global.post_messages_with_bot(help_messages, bot_id)
    elsif self.has_keyword?('s')
      message = ['Enter sales at http://sprint.rbdconnect.com/']
      GroupMe.new_global.post_messages_with_bot(message, bot_id)
    elsif self.has_keyword?('schedule')
      message = ['Schedule your new SalesMaker for training at http://goo.gl/zH8cOi !']
      GroupMe.new_global.post_messages_with_bot(message, bot_id)
    elsif self.has_keyword?('training')
      message = ['https://docs.google.com/a/retaildoneright.com/forms/d/1QP2zs_r_wO77eOYBYVinpGBvIcY0931T3SBapjZYXmE/viewform']
      GroupMe.new_global.post_messages_with_bot(message, bot_id)
    else
      self.sales_and_hpa_messages
    end
  end

  def sales_and_hpa_messages
    set_level
    determine_date_range
    generate_message_content
    post_messages
  end

  def generate_message_content
    if self.has_keyword? 'hpa'
      @results = hpa_query
      check_environment
      @messages = hpa_generate_messages(@results)
    else
      @results = sales_query
      check_environment
      @messages = sales_generate_messages(@results)
    end
    @messages
  end

  protected

  def set_level
    level_keywords = ['rep', 'brand', 'market', 'region', 'director', 'territory']
    level_keywords.each do |key|
      if self.has_keyword? key
        @level = key
      end
    end
    if @level == nil
      @level = 'rep'
    end
  end

  def hpa_query
    query 'hpa'
  end

  def sales_query
    query 'sales'
  end

  def query(type = 'sales')
    select = self.send(type + '_' + @level + '_query')
    select = self.send(type + '_wrap_query', (select))
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
        'east',
        'west',
        'market',
        'region',
        'brand',
        'last',
        'this',
        'week',
        'weekend',
        'month',
        'yesterday',
        'today',
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

  def post_messages
    if @messages.empty?
      @messages = [@query_string.empty? ? "No Results" : "No results for '#{@query_string}'"]
      @chart_url = nil
    end
    GroupMe.new_global.post_messages_with_bot(@messages, bot_id, @chart_url)
  end
end