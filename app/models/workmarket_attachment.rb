class WorkmarketAttachment < ActiveRecord::Base
  validates :workmarket_assignment, presence: true
  validates :filename, length: { minimum: 1 }
  validates :url, length: { minimum: 14 }
  validates :guid, length: { minimum: 1 }

  belongs_to :workmarket_assignment
end
