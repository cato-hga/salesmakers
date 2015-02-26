require 'apis/groupme'

class GroupMeGroupsController < ApplicationController
  before_action :set_message
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: [:new_post]

  def new_post
    @group_me_groups = policy_scope(GroupMeGroup)
    authorize GroupMeGroup.new
  end

  def post
    authorize GroupMeGroup.new
    group_me_group_ids = check_group_me_group_ids
    message = check_message
    render :new and return unless group_me_group_ids and message
    add_bots_and_post group_me_group_ids, message
    flash[:notice] = 'Message successfully sent to GroupMe for delivery.'
    redirect_to new_post_group_me_groups_path
  end

  private

  def set_message
    @message = post_params[:message] ? post_params[:message] : nil
  end

  def post_params
    params.permit :message, {:group_me_group_ids => []}
  end

  def check_message
    message = post_params[:message]
    unless message and message.length > 10
      flash[:error] = "You must select at least "
      false
    else
      message
    end
  end

  def check_group_me_group_ids
    group_me_group_ids = post_params[:group_me_group_ids]
    unless group_me_group_ids and group_me_group_ids.count > 0
      flash[:error] = "You must select a group to post to."
      false
    else
      group_me_group_ids
    end
  end

  def add_bots_and_post(group_me_group_ids, message)
    group_me = GroupMe.new_global
    for group_me_group_id in group_me_group_ids do
      group_me_group = GroupMeGroup.find group_me_group_id.to_i
      bot_name = "#{@current_person.display_name} via SalesCenter 2.0"
      bot_id = group_me.add_bot bot_name, group_me_group.group_num
      next unless bot_id
      group_me.post_messages_with_bot [message], bot_id
      group_me.destroy_bot bot_id
    end
  end
end