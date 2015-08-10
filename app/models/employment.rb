# == Schema Information
#
# Table name: employments
#
#  id         :integer          not null, primary key
#  person_id  :integer
#  start      :date
#  end        :date
#  end_reason :string
#  created_at :datetime
#  updated_at :datetime
#

class Employment < ActiveRecord::Base
  belongs_to :person

  validates :start, presence: true

  default_scope { order start: :desc }

  def end_from_connect
    connect_user = get_connect_user || return
    termination = get_connect_termination
    ended = termination ? termination.last_day_worked : connect_user.updated.to_date
    ended = connect_user.lastcontact.to_date if connect_user.lastcontact
    reason = 'Not Recorded'
    if termination and termination.connect_termination_reason
      reason = termination.connect_termination_reason.reason
    end
    self.update end: ended, end_reason: reason
  end

  def get_connect_termination
    terminations = get_connect_user.connect_terminations
    return unless terminations.count > 0
    terminations.first
  end

  def get_connect_user
    self.person.connect_user
  end
end
