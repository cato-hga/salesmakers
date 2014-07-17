class Department < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 5 }

  has_many :positions

  default_scope { order :name }
end
