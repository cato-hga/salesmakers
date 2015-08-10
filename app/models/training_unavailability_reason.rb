# == Schema Information
#
# Table name: training_unavailability_reasons
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TrainingUnavailabilityReason < ActiveRecord::Base
  validates :name, presence: true

  has_many :training_availabilities

  default_scope { order :name }
end
