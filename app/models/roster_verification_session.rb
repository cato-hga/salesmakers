class RosterVerificationSession < ActiveRecord::Base
  validates :creator, presence: true

  belongs_to :creator, class_name: 'Person'
  has_many :roster_verifications

  accepts_nested_attributes_for :roster_verifications
end