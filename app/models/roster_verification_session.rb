# == Schema Information
#
# Table name: roster_verification_sessions
#
#  id                :integer          not null, primary key
#  creator_id        :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  missing_employees :string
#

class RosterVerificationSession < ActiveRecord::Base
  validates :creator, presence: true

  belongs_to :creator, class_name: 'Person'
  has_many :roster_verifications

  accepts_nested_attributes_for :roster_verifications

  strip_attributes
end
