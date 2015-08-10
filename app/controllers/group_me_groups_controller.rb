require 'apis/groupme'

class GroupMeGroupsController < ApplicationController
  before_action :set_message
  after_action :verify_authorized
  after_action :verify_policy_scoped

  def new_post
    @group_me_groups = policy_scope(GroupMeGroup)
    @schedule = nil
    authorize GroupMeGroup.new
  end

  def post
    @group_me_groups = policy_scope(GroupMeGroup)
    @schedule_when = post_params[:schedule]
    authorize GroupMeGroup.new
    check_params
    unless @group_me_group_ids && (@message || @file)
      render :new_post and return
    end
    add_bots_and_post
    message = 'Message successfully sent to GroupMe for delivery'
    message += ' on ' + @schedule.strftime('%m/%d/%Y at %-l:%M%P.') if @schedule
    flash[:notice] = "#{message}."
    redirect_to new_post_group_me_groups_path
  end

  private

  def set_message
    @message = post_params[:message] ? post_params[:message] : nil
  end

  def post_params
    params.permit :message, :file, :schedule, {:group_me_group_ids => []}
  end

  def check_params
    @group_me_group_ids = check_group_me_group_ids
    @file = check_file
    if @file
      @is_image = FastImage.type File.path(@file)
    end
    @message = check_message
  end

  def check_message
    message = post_params[:message]
    unless (message && message.length > 4) || @file
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
    @original_filename = uploaded_io.original_filename
    uuid = SecureRandom.uuid
    new_filename = Rails.root.join('public', 'uploads', "#{uuid}_#{uploaded_io.original_filename}")
    File.open(new_filename, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    FileUtils.ln_s new_filename, "#{new_filename}.avatar"
    FileUtils.ln_s new_filename, "#{new_filename}.preview"
    FileUtils.ln_s new_filename, "#{new_filename}.large"
    File.new new_filename
  end

  def add_bots_and_post
    schedule
    @group_me = GroupMe.new_global
    for group_me_group_id in @group_me_group_ids do
      group_me_group = GroupMeGroup.find group_me_group_id.to_i
      post_message(group_me_group)
    end
  end

  def schedule
    Chronic.time_class = Time.zone
    if post_params[:schedule]
      @schedule = Chronic.parse(post_params[:schedule])
    else
      @schedule = Time.now
    end
    Chronic.time_class = Time
    @schedule
  end

  def post_message(group_me_group)
    if @file and @is_image
      GroupMeBotPostJob.set(wait_until: @schedule).
          perform_later [@message],
                        @current_person.display_name,
                        group_me_group.group_num,
                        get_url_to_file
    elsif @file and not @is_image
      send_attachment_messages(@message, group_me_group)
    else
      GroupMeBotPostJob.set(wait_until: @schedule).
          perform_later [@message],
                        @current_person.display_name,
                        group_me_group.group_num
    end
  end

  def get_url_to_file
    if Rails.env.staging? || Rails.env.production?
      URI::encode(root_url + 'uploads/' + File.basename(@file))
    else
      URI::encode('http://localhost:3000' + '/uploads/' + File.basename(@file))
    end
  end

  def send_attachment_messages(message, group_me_group)
    upload_message = build_upload_message
    unless upload_message
      GroupMeBotPostJob.set(wait_until: @schedule).
          perform_later [@message],
                        @current_person.display_name,
                        group_me_group.group_num and return
    end
    if message and message.length > 0
      messages = [message, upload_message]
    else
      messages = [upload_message]
    end
    GroupMeBotPostJob.set(wait_until: @schedule).
        perform_later messages,
                      @current_person.display_name,
                      group_me_group.group_num
  end

  def build_upload_message
    upload_message = "Download your copy of '#{@original_filename}' here: "
    begin
      upload_message += Bitly.client.shorten(get_url_to_file).short_url
    rescue BitlyError
      return nil
    end
    upload_message
  end

end