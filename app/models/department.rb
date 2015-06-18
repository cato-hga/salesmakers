class Department < ActiveRecord::Base
  #after_save :create_wall
  validates :name, presence: true, length: { minimum: 5 }

  has_many :positions
  has_many :people, through: :positions

  default_scope { order :name }

  private

  # def create_wall
  #   return if self.wall
  #   Wall.create wallable: self
  # end
end
