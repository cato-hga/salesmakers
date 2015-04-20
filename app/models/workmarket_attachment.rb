class WorkmarketAttachment < ActiveRecord::Base
  validates :workmarket_assignment, presence: true
  validates :filename, length: { minimum: 1 }
  validates :url, length: { minimum: 14 }

  belongs_to :workmarket_assignment
end
