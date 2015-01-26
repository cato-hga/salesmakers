class ComcastCustomer < ActiveRecord::Base

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :person_id, presence: true

  belongs_to :person

end
