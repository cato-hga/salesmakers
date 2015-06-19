# == Schema Information
#
# Table name: vonage_account_status_changes
#
#  id                 :integer          not null, primary key
#  mac                :string           not null
#  account_start_date :date             not null
#  account_end_date   :date
#  status             :integer          not null
#  termination_reason :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class VonageAccountStatusChange < ActiveRecord::Base
  enum status: [:active, :grace, :suspended, :terminated]

  validates :mac, length: { is: 12 }
  validates :account_start_date, presence: true
  validates :status, presence: true
  validate :account_start_date_in_past
  validate :termination_fields
  has_many :vonage_refunds

  def matches_latest?
    return false unless self.mac
    records = VonageAccountStatusChange.where(mac: self.mac).order(:created_at)
    return false if records.empty?
    latest_attributes = records.last.attributes.except("created_at",
                                                       "updated_at",
                                                       "id")
    self_attributes = self.attributes.except("created_at", "updated_at", "id")
    self_attributes == latest_attributes
  end

  private

  def account_start_date_in_past
    return unless self.account_start_date
    if self.account_start_date > Date.today
      errors.add(:account_start_date, 'cannot be in the future')
    end
  end

  def termination_fields
    return unless self.status
    if self.terminated? and self.account_end_date.blank?
      errors.add(:account_start_date, 'must be present for terminations')
    end
    if self.terminated? and self.termination_reason.blank?
      errors.add(:termination_reason, 'must be present for terminations')
    end
  end
end
