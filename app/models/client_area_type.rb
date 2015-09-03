# == Schema Information
#
# Table name: client_area_types
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  project_id :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class ClientAreaType < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 3 }
  validates :project, presence: true

  belongs_to :project
  has_many :client_areas

  default_scope { order :name }

  strip_attributes
end
