class RosterVerification < ActiveRecord::Base
  before_validation :nilify_issue

  validates :creator, presence: true
  validates :person, presence: true
  validates :status, presence: true
  validates :roster_verification_session, presence: true
  validates :issue, presence: true, if: :issue?

  belongs_to :roster_verification_session
  belongs_to :creator, class_name: 'Person'
  belongs_to :person
  belongs_to :location

  enum status: [:active, :terminate, :issue]

  private

  def nilify_issue
    if self.issue == ''
      self.issue = nil
    end
  end
end