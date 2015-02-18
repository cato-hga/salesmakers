class ComcastLead < ActiveRecord::Base
  validates :comcast_customer, presence: true
  validate :one_service_selected
  validate :no_past_follow_up_by_date
  validate :must_be_ok_to_call_and_text

  belongs_to :comcast_customer

  delegate :name, to: :comcast_customer
  delegate :mobile_phone, to: :comcast_customer
  delegate :other_phone, to: :comcast_customer

  default_scope {
    joins(:comcast_customer).
        where(active: true).
        order('comcast_customers.first_name, comcast_customers.last_name')

  }

  scope :person, ->(person_id) {
    where('comcast_customers.person_id = ?', person_id)
  }

  scope :overdue, -> {
    where('follow_up_by < ?', Date.today).order(:follow_up_by)
  }

  scope :upcoming, -> {
    where('follow_up_by >= ? AND follow_up_by <= ?',
          Date.today,
          Date.today + 1.week).order(:follow_up_by)
  }

  scope :not_upcoming_or_overdue, -> {
    where('follow_up_by > ? OR follow_up_by IS NULL', Date.today + 1.week)
  }

  def self.policy_class
    ComcastCustomerPolicy
  end

  private

  def one_service_selected
    unless self.tv? or self.internet? or self.phone? or self.security?
      [:tv, :internet, :phone, :security].each do |product|
        errors.add(product, 'or at least one other product must be selected')
      end
    end
  end

  def no_past_follow_up_by_date
    return unless self.follow_up_by
    if self.follow_up_by.to_date <= Date.today and not self.persisted?
      errors.add(:follow_up_by, 'must be in the future')
    end
  end

  def must_be_ok_to_call_and_text
    unless self.ok_to_call_and_text?
      errors.add(:ok_to_call_and_text, 'must be checked to save as a lead')
    end
  end

end
