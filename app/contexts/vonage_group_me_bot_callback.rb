require 'apis/groupme'
require 'group_me_bot_query'
require_relative 'group_me_bot_sales_messages'
require_relative 'vonage_group_me_bot_help'
require_relative 'vonage_group_me_bot_sales_query'

class VonageGroupMeBotCallback
  include GroupMeBotQuery
  include VonageGroupMeBotHelp
  include GroupMeBotSalesMessages
  include VonageGroupMeBotSalesQuery

  attr_accessor :query_string,
                :keywords

  attr_reader :bot_id

  def initialize(json)
    @callback = GroupMeBotCallback.new(json)
  end

  def process
    return unless @callback and @callback.group_id
    group_me_bot = VonageGroupMeBot.find_by group_num: @callback.group_id
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
      message = ['Enter sales at http://v.rbdconnect.com/']
      GroupMe.new_global.post_messages_with_bot(message, bot_id)
    elsif self.has_keyword?('schedule')
      message = ['Schedule your new SalesMaker for training at http://goo.gl/zH8cOi !']
      GroupMe.new_global.post_messages_with_bot(message, bot_id)
    else
      self.sales_messages
    end
  end

  def sales_messages
    set_level
    determine_date_range
    generate_message_content
    post_messages
  end

  def generate_message_content
    @results = query
    check_environment
    @messages = sales_generate_messages(@results)
    @messages
  end

  protected

  def set_level
    level_keywords = ['rep', 'market', 'region', 'territory']
    level_keywords.each do |key|
      if self.has_keyword? key
        @level = key
      end
    end
    if @level == nil
      @level = 'rep'
    end
  end

  def query
    select = self.send('sales_' + @level + '_query')
    select = self.send('sales_wrap_query', (select))
    results = ActiveRecord::Base.connection.execute select.to_s
    # begin
    #   tries ||= 3
    #   connection = ConnectDatabaseConnection.establish_connection(:rbd_connect_production).connection
    #   sleep 0.1
    #   results = connection.execute(select)
    # rescue ActiveRecord::StatementInvalid, PG::ConnectionBad
    #   sleep 0.1
    #   retry unless (tries -= 1).zero?
    # end
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
        'market',
        'region',
        'last',
        'this',
        'week',
        'weekend',
        'month',
        'yesterday',
        'today',
        'vonage',
        'no',
        'sales',
        'and',
        'with',
        's',
        'referral',
        'schedule',
        'training',
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