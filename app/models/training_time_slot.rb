# == Schema Information
#
# Table name: training_time_slots
#
#  id                     :integer          not null, primary key
#  training_class_type_id :integer          not null
#  start_date             :datetime         not null
#  end_date               :datetime         not null
#  monday                 :boolean          default(FALSE), not null
#  tuesday                :boolean          default(FALSE), not null
#  wednesday              :boolean          default(FALSE), not null
#  thursday               :boolean          default(FALSE), not null
#  friday                 :boolean          default(FALSE), not null
#  saturday               :boolean          default(FALSE), not null
#  sunday                 :boolean          default(FALSE), not null
#  person_id              :integer          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'validators/training_time_slot_validator'
class TrainingTimeSlot < ActiveRecord::Base

  validates :training_class_type_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :person_id, presence: true
  validates_with TrainingTimeSlotValidator

  belongs_to :training_class_type
  belongs_to :person

end


