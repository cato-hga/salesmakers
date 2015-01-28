class ComcastSale < ActiveRecord::Base
  validates :sale_date, presence: true
  validates :person_id, presence: true
  validates :comcast_customer_id, presence: true
  validates :comcast_install_appointment, presence: true
  validate :one_selected

  belongs_to :comcast_customer
  belongs_to :person
  has_one :comcast_install_appointment, inverse_of: :comcast_sale
  accepts_nested_attributes_for :comcast_install_appointment

  private

  def one_selected
    unless self.tv? or self.internet? or self.phone? or self.security?
      [:tv, :internet, :phone, :security].each do |product|
        errors.add(product, 'or at least one other product must be selected')
      end
    end
  end

end
