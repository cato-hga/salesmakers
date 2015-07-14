module DirecTV::LeadValidationsAndAssociations
  def setup_validations
    validates :directv_customer, presence: true
    validate :no_past_follow_up_by_date
    validate :must_be_ok_to_call_and_text
  end

  def belongs_to_associations
    belongs_to :directv_customer
    accepts_nested_attributes_for :directv_customer
  end
end