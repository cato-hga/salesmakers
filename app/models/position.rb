class Position < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 5 }
  validates :department, presence: true

  belongs_to :department
end
