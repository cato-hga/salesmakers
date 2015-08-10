# == Schema Information
#
# Table name: technology_service_providers
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#

class TechnologyServiceProvider < ActiveRecord::Base

  validates :name, presence: true, length: { minimum: 3 }
end
