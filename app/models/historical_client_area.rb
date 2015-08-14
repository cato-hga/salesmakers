# == Schema Information
#
# Table name: historical_client_areas
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  client_area_type_id :integer          not null
#  ancestry            :string
#  project_id          :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  date                :date             not null
#

class HistoricalClientArea < ActiveRecord::Base
  validates :date, presence: true
  validates :name, presence: true, length: { minimum: 3 }
  validates :client_area_type, presence: true

  belongs_to :client_area_type
  belongs_to :project
end
