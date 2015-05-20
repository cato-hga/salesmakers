require 'comcast/sales_and_leads'
require 'comcast/sale_scopes'
require 'comcast/sale_validations_and_associations'

class ComcastSale < ActiveRecord::Base
  include Comcast::SalesAndLeads
  extend Comcast::SaleScopes
  extend Comcast::SaleValidationsAndAssociations

  set_scopes
  setup_validations
  belongs_to_associations
  has_one_assocations

  def rgus
    rgus = 0
    [self.tv?, self.internet?, self.phone?, self.security?].each {|rgu| rgus += (rgu ? 1 : 0)}
    rgus
  end

  def link
    return '' unless self.comcast_customer
    if Rails.env.staging? || Rails.env.production?
      Rails.application.routes.url_helpers.comcast_customer_url(self.comcast_customer)
    else
      Rails.application.routes.url_helpers.comcast_customer_url(self.comcast_customer, host: 'localhost:3000')
    end
  end

  def entered_by_name
    return unless self.person
    self.person.display_name
  end

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








