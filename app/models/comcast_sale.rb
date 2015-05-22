require 'comcast/sales_and_leads'
require 'comcast/sale_scopes'
require 'comcast/sale_validations_and_associations'
require 'sales_leads_customers/sales_leads_customers_model_extension'

class ComcastSale < ActiveRecord::Base
  include Comcast::SalesAndLeads
  include SalesLeadsCustomersModelExtension
  extend Comcast::SaleScopes
  extend Comcast::SaleValidationsAndAssociations

  set_scopes
  setup_validations
  belongs_to_associations
  has_one_assocations

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

end
