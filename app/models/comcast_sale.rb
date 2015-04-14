require 'comcast/sales_and_leads'
require 'comcast_sale_scopes'

class ComcastSale < ActiveRecord::Base
  include Comcast::SalesAndLeads
  extend ComcastSaleScopes

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

  set_scopes

  private

  def within_24_hours
    return unless self.order_date
    if self.order_date.to_date < Date.today - 1.day
      errors.add(:order_date, 'cannot be more than 24 hours in the past')
    end
  end

  def no_future_sales
    return unless self.order_date
    if self.order_date.to_date > Date.today
      errors.add(:order_date, 'cannot be in the future')
    end
  end

end








