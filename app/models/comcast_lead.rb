require 'comcast/sales_and_leads'
require 'comcast/lead_validations_and_associations'
require 'comcast/lead_scopes'

class ComcastLead < ActiveRecord::Base
  include Comcast::SalesAndLeads
  extend Comcast::LeadScopes
  extend Comcast::LeadValidationsAndAssociations

  setup_validations
  setup_scopes
  belongs_to_associations

  delegate :name, to: :comcast_customer
  delegate :mobile_phone, to: :comcast_customer
  delegate :other_phone, to: :comcast_customer

  def self.policy_class
    ComcastCustomerPolicy
  end

  def comcast_customer_name
    if self.comcast_customer
      self.comcast_customer.name
    else
      nil
    end
  end

  def comcast_customer_mobile_phone
    if self.comcast_customer
      self.comcast_customer.mobile_phone
    else
      nil
    end
  end

  def comcast_customer_other_phone
    if self.comcast_customer
      self.comcast_customer.other_phone
    else
      nil
    end
  end

  def link
    return '' unless self.comcast_customer
    if Rails.env.staging? || Rails.env.production?
      Rails.application.routes.url_helpers.comcast_customer_url(self.comcast_customer)
    else
      Rails.application.routes.url_helpers.comcast_customer_url(self.comcast_customer, host: 'localhost:3000')
    end
  end

  def converted_to_sale
    return false unless self.comcast_customer and self.comcast_customer.comcast_sale
    true
  end

  def entered_by_name
    return unless self.comcast_customer
    self.comcast_customer.person.display_name
  end

  private

  def no_past_follow_up_by_date
    return unless self.follow_up_by
    if self.follow_up_by.to_date <= Date.current and not self.persisted?
      errors.add(:follow_up_by, 'must be in the future')
    end
  end

  def must_be_ok_to_call_and_text
    unless self.ok_to_call_and_text?
      errors.add(:ok_to_call_and_text, 'must be checked to save as a lead')
    end
  end

end
