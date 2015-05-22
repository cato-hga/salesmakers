require 'directv/sales_and_leads'
require 'directv/sale_scopes'
require 'directv/sale_validations_and_associations'
require 'sales_leads_customers/sales_leads_customers_model_extension'

class DirecTVSale < ActiveRecord::Base
  include DirecTV::SalesAndLeads
  include SalesLeadsCustomersModelExtension
  extend DirecTV::SaleScopes
  extend DirecTV::SaleValidationsAndAssociations

  set_scopes
  setup_validations
  belongs_to_associations
  has_one_assocations

end

