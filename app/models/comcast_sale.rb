class ComcastSale < ActiveRecord::Base
  validates :sale_date, presence: true
  validates :person_id, presence: true
  validates :comcast_customer_id, presence: true
  validates :comcast_install_appointment, presence: true
  validate :one_service_selected
  validate :no_future_sales

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

  def one_service_selected
    unless self.tv? or self.internet? or self.phone? or self.security?
      [:tv, :internet, :phone, :security].each do |product|
        errors.add(product, 'or at least one other product must be selected')
      end
    end
  end

  def no_future_sales
    return unless self.sale_date
    if self.sale_date.to_date > Date.today
      errors.add(:sale_date, 'cannot be in the future')
    end
  end

end
