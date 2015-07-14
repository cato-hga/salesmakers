module Comcast::LeadValidationsAndAssociations
  def setup_validations
    validates :comcast_customer, presence: true
    validate :one_service_selected
    validate :no_past_follow_up_by_date
    validate :must_be_ok_to_call_and_text
  end

  def belongs_to_associations
    belongs_to :comcast_customer
    accepts_nested_attributes_for :comcast_customer
  end
end