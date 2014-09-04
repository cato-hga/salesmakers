require 'apis/groupme'
require 'json'

class GroupMesController < ApplicationController
  skip_before_action CASClient::Frameworks::Rails::Filter, only: :incoming_bot_message
  protect_from_forgery except: :incoming_bot_message
  before_action :setup_groupme, except: :incoming_bot_message
  layout false

  def auth
    redirect_to 'https://oauth.groupme.com/oauth/authorize?client_id=UeyAKMhjQFp1oai4Fs838Vvz9qneTW11ZWeMRgs1U2AIz5vw'
  end

  def called_back
    if params[:access_token] and current_user
      current_user.update groupme_access_token: params[:access_token],
                          groupme_token_updated: Time.now
      setup_groupme
      group_me_user_json = @groupme.get_me
      GroupMeUser.find_or_create_from_json group_me_user_json, @current_person
    end

    redirect_to root_url
  end

  def incoming_bot_message
    json = request.body.read
    existing_message = GroupMePost.find_by message_num: params[:id]
    return if existing_message
    group_me_user = GroupMeUser.find_by group_me_user_num: params[:user_id]
    unless group_me_user
      GroupMeGroup.update_group params[:group_id]
      group_me_user = GroupMeUser.find_by group_me_user_num: params[:user_id]
    end
    post = GroupMePost.create group_me_group_id: params[:group_id],
                              message_num: params[:id],
                              posted_at: Time.now,
                              json: json,
                              group_me_user: group_me_user
  end


  def groups
    groups = @groupme.get_groups
    respond_with groups
  end

  def groups_aside
    groups = @groupme.get_groups
    if groups and groups['response']
      @groups = groups['response']
    else
      []
    end
  end

  def group_chat_aside
    @messages = @groupme.get_messages(params[:group_id], 10)
    @group_id = params[:group_id]
  end


  def post_message
    @response = @groupme.send_message params[:group_id], params[:message]
  end


  private

  def setup_groupme
    @groupme = GroupMe.new current_user.groupme_access_token
  end

end