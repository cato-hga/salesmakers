require 'apis/groupme'

class HomeController < ApplicationController
  def index
    groupme = GroupMe.new
    messages = groupme.get_recent_messages 5
    messages = messages.sort
    @messages = (messages.count < 15) ? messages.reverse : messages[0..14].reverse
  end
end
