class VonageSale < ActiveRecord::Base
  validates :sale_date, presence: true
  validates :person, presence: true
  validates :confirmation_number, length: { is: 10 }
  validates :location, presence: true
  validates :customer_first_name, presence: true
  validates :customer_last_name, presence: true
  validates :mac_id, length: { is: 12 }
  validates :vonage_product, presence: true

  belongs_to :person
  belongs_to :location
  belongs_to :vonage_product
end
