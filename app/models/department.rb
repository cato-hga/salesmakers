class Department < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 5 }

  has_many :positions
  has_many :people, through: :positions

  default_scope { order :name }
end
