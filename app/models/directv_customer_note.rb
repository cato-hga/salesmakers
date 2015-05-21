class DirecTVCustomerNote < ActiveRecord::Base
  validates :person, presence: true
  validates :directv_customer, presence: true
  validates :note, length: { minimum: 5 }

  belongs_to :directv_customer
  belongs_to :person
end
