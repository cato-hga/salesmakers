class ComcastSale < ActiveRecord::Base

  validates :sale_date, presence: true
  validates :person_id, presence: true, uniqueness: true
  validates :comcast_customer_id, presence: true, uniqueness: true

  belongs_to :comcast_customer
  belongs_to :person
end
