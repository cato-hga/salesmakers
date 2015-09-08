# == Schema Information
#
# Table name: comcast_sales
#
#  id                         :integer          not null, primary key
#  order_date                 :date             not null
#  person_id                  :integer          not null
#  comcast_customer_id        :integer          not null
#  order_number               :string           not null
#  tv                         :boolean          default(FALSE), not null
#  internet                   :boolean          default(FALSE), not null
#  phone                      :boolean          default(FALSE), not null
#  security                   :boolean          default(FALSE), not null
#  customer_acknowledged      :boolean          default(FALSE), not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  comcast_former_provider_id :integer
#  comcast_lead_id            :integer
#

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
  has_one_associations
  strip_attributes

  has_many :log_entries, as: :trackable, dependent: :destroy


end
