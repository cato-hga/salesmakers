class Project < ActiveRecord::Base

  validates :name, presence: true, length: { minimum: 4 }
  validates :client, presence: true

  belongs_to :client
  has_many :area_types
  has_many :areas

  default_scope { order(:name) }
end
