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
  has_one :comcast_lead

  default_scope {
    joins(:person, :comcast_install_appointment).
        order('comcast_install_appointments.install_date DESC, people.display_name ASC')
  }

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

  scope :sold_between_dates, ->(start_date, end_date) {
    return none unless start_date and end_date
    where('order_date >= ? AND order_date < ?', start_date, end_date)
  }

  def comcast_customer_name
    self.comcast_customer.name
  end

  def comcast_customer_mobile_phone
    self.comcast_customer.mobile_phone
  end

  def comcast_customer_other_phone
    self.comcast_customer.other_phone
  end

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
