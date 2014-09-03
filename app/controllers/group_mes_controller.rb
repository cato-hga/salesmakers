require 'apis/groupme'
require 'json'

class GroupMesController < ApplicationController
  before_action :setup_groupme
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
      GroupMeUser.create_from_json group_me_user_json, @current_person
    end

    redirect_to root_url
  end

  def incoming_bot_message
    #existing_message = GroupMePost.find_by
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