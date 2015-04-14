require 'uri'
require 'open-uri'
require 'fileutils'
require 'httparty'
require 'apis/group_me_emoji_filter'
require 'apis/groupme/group_me_api_message'
require 'apis/authorized_api'
require 'apis/groupme/attachments'
require 'apis/groupme/bots'
require 'apis/groupme/groups'
require 'apis/groupme/messages'

class GroupMe
  include HTTParty
  include AuthorizedAPI
  include Groupme::Attachments
  include Groupme::Bots
  include Groupme::Groups
  include Groupme::Messages

  base_uri 'https://api.groupme.com/v3'
  format :json

  def initialize(access_token)
    @access_token = access_token
  end

  def authorization_hash
    {
        token: @access_token
    }
  end

  def self.new_global
    self.new '1956b1d08a050132df253a66af516754'
  end

  def get_me
    response = doGet '/users/me'
    return response['response'] if response and response['response']
    nil
  end
end