# == Schema Information
#
# Table name: departments
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  corporate  :boolean          not null
#  created_at :datetime
#  updated_at :datetime
#

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
