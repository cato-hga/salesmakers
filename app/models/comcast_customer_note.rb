class ComcastCustomerNote < ActiveRecord::Base
  validates :person, presence: true
  validates :comcast_customer, presence: true
  validates :note, length: { minimum: 5 }

  belongs_to :comcast_customer
  belongs_to :person
end
