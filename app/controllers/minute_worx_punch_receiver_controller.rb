require 'apis/groupme'

class MinuteWorxPunchReceiverController < ApplicationController
  layout false
  protect_from_forgery except: :incoming

  skip_before_action CASClient::Frameworks::Rails::Filter
  skip_before_action :set_current_user,
                     :check_active,
                     :get_projects,
                     :setup_default_walls,
                     :set_last_seen,
                     :set_last_seen_profile,
                     :setup_new_publishables,
                     :filter_groupme_access_token,
                     :setup_accessibles,
                     :verify_authenticity_token

  def begin
    punch_data = JSON.parse params[:data]
    email = punch_data.andand['Employee'].andand['email_work'] || (render(nothing: true) and return)
    timestamp_text = punch_data.andand['Punch'].andand['timestamp'] || (render(nothing: true) and return)
    punch_type_text = punch_data.andand['Punch'].andand['punch_type_text'] || (render(nothing: true) and return)
    person = Person.find_by email: email
    begin
      timestamp = Time.strptime timestamp_text, '%Y-%m-%dT%H:%M:%S%:z'
    rescue
      render nothing: true and return
    end
    punch_type = punch_type_text.include?('Out') ? :out : :in
    punch = PersonPunch.create identifier: email,
                               punch_time: timestamp,
                               in_or_out: punch_type,
                               person: person || (render(nothing: true) and return)
    send_punch_to_group_me punch
    render text: 'ok'
  end

  private

  def send_punch_to_group_me punch
    return unless punch.person
    group_me = GroupMe.new_global
    groups = punch.person.group_me_groups
    for group in groups do
      group.send_message "#{punch.person.display_name} just punched #{punch.in_or_out.to_s} at #{punch.punch_time.in_time_zone(ActiveSupport::TimeZone.new("Eastern Time (US & Canada)")).strftime('%-l:%M%P')} Eastern."
    end
  end

end