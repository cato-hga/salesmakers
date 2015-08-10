# == Schema Information
#
# Table name: training_classes
#
#  id                     :integer          not null, primary key
#  training_class_type_id :integer
#  training_time_slot_id  :integer
#  date                   :datetime
#  person_id              :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class TrainingClass < ActiveRecord::Base

  validates :training_class_type_id, presence: true
  validates :training_time_slot_id, presence: true
  validates :person_id, presence: true
  validates :date, presence: true

  belongs_to :training_class_type
  belongs_to :training_time_slot
  belongs_to :person
end
