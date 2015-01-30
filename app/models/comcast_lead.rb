class ComcastLead < ActiveRecord::Base
  validates :comcast_customer, presence: true
  validate :one_service_selected
  validate :no_past_follow_up_by_date

  belongs_to :comcast_customer

  default_scope {
    joins(:comcast_customer).order('comcast_customers.first_name, comcast_customers.last_name')
  }

  scope :overdue, -> {
    where('follow_up_by < ?', Date.today)
  }

  scope :upcoming, -> {
    where('follow_up_by >= ? AND follow_up_by <= ?',
          Date.today,
          Date.today + 1.week)
  }

  scope :not_upcoming_or_overdue, -> {
    where('follow_up_by > ? OR follow_up_by IS NULL', Date.today + 1.week)
  }

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
    if self.follow_up_by.to_date <= Date.today
      errors.add(:follow_up_by, 'must be in the future')
    end
  end
end
