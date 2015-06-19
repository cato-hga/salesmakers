# == Schema Information
#
# Table name: training_class_attendees
#
#  id                         :integer          not null, primary key
#  person_id                  :integer          not null
#  training_class_id          :integer          not null
#  attended                   :boolean          default(FALSE), not null
#  dropped_off_time           :datetime
#  drop_off_reason_id         :integer
#  status                     :integer          not null
#  conditional_pass_condition :text
#  group_me_setup             :boolean          default(FALSE), not null
#  time_clock_setup           :boolean          default(FALSE), not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

class TrainingClassAttendee < ActiveRecord::Base

  validates :person_id, presence: true
  validates :training_class_id, presence: true
  validates :attended, presence: true
  validates :status, presence: true
  validates :group_me_setup, presence: true
  validates :time_clock_setup, presence: true

  belongs_to :person
  belongs_to :training_class
end
