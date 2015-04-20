class WorkmarketLocation < ActiveRecord::Base
  validates :workmarket_location_num, presence: true
  validates :name, length: { minimum: 1 }

  has_many :workmarket_assignments
end
