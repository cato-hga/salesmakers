class ComcastSale < ActiveRecord::Base
  validates :order_date, presence: true
  validates :person_id, presence: true
  validates :comcast_customer_id, presence: true
  validates :comcast_install_appointment, presence: true
  validates :order_number, length: {is: 13}, numericality: {only_integer: true}, uniqueness: true
  validate :one_service_selected
  validate :no_future_sales
  validate :within_24_hours

  belongs_to :comcast_customer
  belongs_to :person
  has_one :comcast_install_appointment, inverse_of: :comcast_sale
  accepts_nested_attributes_for :comcast_install_appointment
  has_one :comcast_former_provider

  scope :person, ->(person_id) {
    where(person_id: person_id)
  }

  scope :recent_installations, -> {
    joins(:comcast_install_appointment).
        where('comcast_install_appointments.install_date > ?',
              Date.today - 1.week).
        where('comcast_install_appointments.install_date < ?',
              Date.today).
        order('comcast_install_appointments.install_date')
  }

  scope :upcoming_installations, -> {
    joins(:comcast_install_appointment).
        where('comcast_install_appointments.install_date < ?',
              Date.today + 1.week).
        where('comcast_install_appointments.install_date >= ?',
              Date.today).
        order('comcast_install_appointments.install_date')
  }

  private

  def within_24_hours
    return unless self.order_date
    if self.order_date.to_date < Date.today - 1.day
      errors.add(:order_date, 'cannot be more than 24 hours in the past')
    end
  end

  def one_service_selected
    unless self.tv? or self.internet? or self.phone? or self.security?
      [:tv, :internet, :phone, :security].each do |product|
        errors.add(product, 'or at least one other product must be selected')
      end
    end
  end

  def no_future_sales
    return unless self.order_date
    if self.order_date.to_date > Date.today
      errors.add(:order_date, 'cannot be in the future')
    end
  end

end
