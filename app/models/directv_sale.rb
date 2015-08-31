# == Schema Information
#
# Table name: directv_sales
#
#  id                         :integer          not null, primary key
#  order_date                 :date             not null
#  person_id                  :integer
#  directv_customer_id        :integer          not null
#  order_number               :string           not null
#  directv_former_provider_id :integer
#  directv_lead_id            :integer
#  customer_acknowledged      :boolean          default(FALSE), not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

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
  strip_attributes

  has_many :log_entries, as: :trackable, dependent: :destroy
end

