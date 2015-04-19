class WorkmarketField < ActiveRecord::Base
  validates :workmarket_assignment, presence: true
  validates :name, length: { minimum: 1 }
  validates :value, length: { minimum: 1 }

  belongs_to :workmarket_assignment
end
