# == Schema Information
#
# Table name: comcast_leads
#
#  id                  :integer          not null, primary key
#  comcast_customer_id :integer          not null
#  follow_up_by        :date
#  tv                  :boolean          default(FALSE), not null
#  internet            :boolean          default(FALSE), not null
#  phone               :boolean          default(FALSE), not null
#  security            :boolean          default(FALSE), not null
#  ok_to_call_and_text :boolean          default(FALSE), not null
#  comments            :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  active              :boolean          default(TRUE), not null
#

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
  has_one_assocations

  has_many :log_entries, as: :trackable, dependent: :destroy


  delegate :name, to: :comcast_customer
  delegate :mobile_phone, to: :comcast_customer
  delegate :other_phone, to: :comcast_customer
  delegate :person, to: :comcast_customer

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

  def converted_to_sale
    return false unless self.comcast_customer and self.comcast_customer.comcast_sale
    true
  end

  def overdue_by_ten
    return true if self.follow_up_by < (Date.today - 10.days)
    false
  end

  def overdue_by_twenty_one
    return true if self.follow_up_by < (Date.today - 21.days)
    false
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
