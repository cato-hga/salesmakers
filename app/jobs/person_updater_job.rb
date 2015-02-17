class PersonUpdaterJob < ActiveJob::Base
  queue_as :default

  def perform(connect_user_id)
    return unless connect_user_id
    connect_user = ConnectUser.find connect_user_id || return
    PersonUpdater.new(connect_user).update
  end
end
