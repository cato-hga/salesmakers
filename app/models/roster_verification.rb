# == Schema Information
#
# Table name: roster_verifications
#
#  id                             :integer          not null, primary key
#  creator_id                     :integer          not null
#  person_id                      :integer          not null
#  status                         :integer          default(0), not null
#  last_shift_date                :date
#  location_id                    :integer
#  envelope_guid                  :string
#  roster_verification_session_id :integer          not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  issue                          :string
#

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
  has_many :log_entries, as: :referenceable, dependent: :destroy


  enum status: [:active, :terminate, :issue]

  private

  def nilify_issue
    if self.issue == ''
      self.issue = nil
    end
  end
end
