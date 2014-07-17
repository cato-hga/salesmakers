class AreaType < ActiveRecord::Base

  validates :name, presence: true, length: { minimum: 3 }
  validates :project, presence: true

  belongs_to :project
  has_many :areas

  default_scope{ order :name }
end
