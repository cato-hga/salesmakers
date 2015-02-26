require 'apis/groupme'

class GroupMeGroupsController < ApplicationController
  before_action :set_message
  after_action :verify_authorized
  after_action :verify_policy_scoped

  def new_post
    @group_me_groups = policy_scope(GroupMeGroup)
    authorize GroupMeGroup.new
  end

  def post
    @group_me_groups = policy_scope(GroupMeGroup)
    authorize GroupMeGroup.new
    check_params
    unless @group_me_group_ids && (@message || @file)
      render :new_post and return
    end
    add_bots_and_post
    flash[:notice] = 'Message successfully sent to GroupMe for delivery.'
    redirect_to new_post_group_me_groups_path
  end

  private

  def set_message
    @message = post_params[:message] ? post_params[:message] : nil
  end

  def post_params
    params.permit :message, :file, {:group_me_group_ids => []}
  end

  def check_params
    @group_me_group_ids = check_group_me_group_ids
    @message = check_message
    @file = check_file
    if @file
      @is_image = FastImage.type @file
    end
  end

  def check_message
    message = post_params[:message]
    unless (message && message.length > 4) || check_file
      flash[:error] = "You must enter a message at least 5 characters long or upload a file."
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

  def check_file
    uploaded_io = post_params[:file]
    return false unless uploaded_io
    new_filename = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
    File.open(new_filename, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    File.new new_filename
  end

  def add_bots_and_post
    @group_me = GroupMe.new_global
    for group_me_group_id in @group_me_group_ids do
      group_me_group = GroupMeGroup.find group_me_group_id.to_i
      bot_name = "#{@current_person.display_name} via SalesCenter 2.0"
      bot_id = @group_me.add_bot bot_name, group_me_group.group_num
      next unless bot_id
      post_message(bot_id)
      @group_me.destroy_bot bot_id
    end
  end

  def post_message(bot_id)
    if @file and @is_image
      @group_me.post_messages_with_bot [@message], bot_id, get_url_to_file
    elsif @file and not @is_image
      send_attachment_messages(@message, bot_id)
    else
      @group_me.post_messages_with_bot [@message], bot_id
    end
  end

  def get_url_to_file
    if Rails.env.staging? || Rails.env.production?
      root_url + '/public/uploads/' + File.basename(@file)
    else
      'http://localhost:3000' + '/public/uploads/' + File.basename(@file)
    end
  end

  def send_attachment_messages(message, bot_id)
    upload_message = build_upload_message
    unless upload_message
      @group_me.post_messages_with_bot [@message], bot_id and return
    end
    if message and message.length > 0
      messages = [message, upload_message]
    else
      messages = [upload_message]
    end
    @group_me.post_messages_with_bot messages, bot_id
  end

  def build_upload_message
    filename = File.basename(@file)
    upload_message = "Download your copy of '#{filename}' here: "
    begin
      upload_message += Bitly.client.shorten(get_url_to_file)
    rescue BitlyError
      return nil
    end
  end

end