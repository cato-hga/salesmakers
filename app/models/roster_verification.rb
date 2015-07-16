class RosterVerification < ActiveRecord::Base
  validates :creator, presence: true
  validates :person, presence: true
  validates :status, presence: true
  validates :roster_verification_session, presence: true

  belongs_to :roster_verification_session
  belongs_to :creator, class_name: 'Person'
  belongs_to :person
  belongs_to :location

  enum status: [:active, :PAF, :NOS]
end
