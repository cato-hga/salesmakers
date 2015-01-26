class ComcastSale < ActiveRecord::Base

  validates :sale_date, presence: true
  validates :person_id, presence: true
  validates :comcast_customer_id, presence: true
  validates :tv, presence: true
  validates :internet, presence: true
  validates :phone, presence: true
  validates :security, presence: true
  validates :customer_acknowledged, presence: true

  belongs_to :comcast_customer
  belongs_to :person
end
