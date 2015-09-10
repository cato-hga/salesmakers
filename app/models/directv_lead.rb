# == Schema Information
#
# Table name: directv_leads
#
#  id                  :integer          not null, primary key
#  active              :boolean          default(TRUE), not null
#  directv_customer_id :integer          not null
#  comments            :text
#  follow_up_by        :date
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  ok_to_call_and_text :boolean
#

require 'directv/sales_and_leads'
require 'directv/lead_validations_and_associations'
require 'directv/lead_scopes'
require 'sales_leads_customers/sales_leads_customers_model_extension'


class DirecTVLead < ActiveRecord::Base
  include DirecTV::SalesAndLeads
  extend DirecTV::LeadScopes
  include SalesLeadsCustomersModelExtension
  extend DirecTV::LeadValidationsAndAssociations

  has_many :log_entries, as: :trackable, dependent: :destroy


  setup_validations
  setup_scopes
  belongs_to_associations
  has_one_associations

  delegate :name, to: :directv_customer
  delegate :mobile_phone, to: :directv_customer
  delegate :other_phone, to: :directv_customer

  def self.policy_class
    DirecTVCustomerPolicy
  end

  def directv_customer_name
    if self.directv_customer
      self.directv_customer.name
    else
      nil
    end
  end

  def directv_customer_mobile_phone
    if self.directv_customer
      self.directv_customer.mobile_phone
    else
      nil
    end
  end

  def directv_customer_other_phone
    if self.directv_customer
      self.directv_customer.other_phone
    else
      nil
    end
  end

  def overdue_by_ten
    if self.directv_customer.directv_customer_notes.any?
      return true if self.directv_customer.directv_customer_notes.last.created_at < (Date.today - 10.days)
    else
      return true if self.follow_up_by and self.follow_up_by < (Date.today - 10.days)
    end
    false
  end

  def overdue_by_twenty_one
    if self.directv_customer.directv_customer_notes.any?
      return true if self.directv_customer.directv_customer_notes.last.created_at < (Date.today - 21.days)
    else
      return true if self.follow_up_by and self.follow_up_by < (Date.today - 21.days)
    end
    false
  end

  def overdue_by_thirty_five
    if self.directv_customer.directv_customer_notes.any?
      return true if self.directv_customer.directv_customer_notes.last.created_at < (Date.today - 35.days)
    else
      return true if self.follow_up_by and self.follow_up_by < (Date.today - 35.days)
    end
    false
  end

  def directv_old_lead_deactivate
    deactivate_old_lead('DirecTV')
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
