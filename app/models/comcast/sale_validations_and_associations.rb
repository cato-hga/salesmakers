module Comcast::SaleValidationsAndAssociations
  def setup_validations
    validates :order_date, presence: true
    validates :person_id, presence: true
    validates :comcast_customer_id, presence: true
    validates :comcast_install_appointment, presence: true
    validates :order_number, length: { is: 13 }, numericality: { only_integer: true }, uniqueness: true
    validate :one_service_selected
    validate :no_future_sales
    validate :within_24_hours
  end

  def belongs_to_associations
    belongs_to :comcast_customer
    belongs_to :person
  end

  def has_one_assocations
    has_one :comcast_former_provider
    has_one :comcast_lead
    has_one :comcast_install_appointment, inverse_of: :comcast_sale
    accepts_nested_attributes_for :comcast_install_appointment
  end
end