module DirecTV::SaleValidationsAndAssociations
  def setup_validations
    validates :order_date, presence: true
    validates :person_id, presence: true
    validates :directv_customer_id, presence: true
    validates :directv_install_appointment, presence: true
    validates :order_number, numericality: { only_integer: true }, uniqueness: true
    validate :no_future_sales
    #validate :within_24_hours
  end

  def belongs_to_associations
    belongs_to :directv_customer
    belongs_to :person
    belongs_to :directv_lead
  end

  def has_one_assocations
    has_one :directv_former_provider
    has_one :directv_install_appointment, inverse_of: :directv_sale
    accepts_nested_attributes_for :directv_install_appointment
  end
end