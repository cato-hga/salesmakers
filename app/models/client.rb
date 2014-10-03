class Client < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 2 }

  has_many :projects
  has_many :day_sales_counts, as: :saleable
end
