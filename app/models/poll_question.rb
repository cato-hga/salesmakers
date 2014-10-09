class PollQuestion < ActiveRecord::Base
  validates :question, length: { minimum: 15 }
  validates :start_time, presence: true
  validate :start_time_after_beginning_of_today
  validate :end_time_before_now

  has_many :poll_question_choices


  private

  def start_time_after_beginning_of_today
    return unless start_time
    return unless new_record?
    beginning_of_day = Time.now.beginning_of_day
    if start_time < beginning_of_day
      errors.add :start_time, 'cannot be before today'
    end
  end

  def end_time_before_now
    return unless end_time
    if end_time < Time.now
      errors.add :end_time, 'cannot be in the past'
    end
  end
end
