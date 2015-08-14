# == Schema Information
#
# Table name: historical_areas
#
#  id                               :integer          not null, primary key
#  name                             :string           not null
#  area_type_id                     :integer          not null
#  ancestry                         :string
#  project_id                       :integer          not null
#  connect_salesregion_id           :string
#  personality_assessment_url       :string
#  area_candidate_sourcing_group_id :integer
#  email                            :string
#  active                           :boolean          default(TRUE), not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  date                             :date             not null
#

class HistoricalArea < ActiveRecord::Base
  belongs_to :area_type
  belongs_to :project
  belongs_to :area_candidate_sourcing_group
  has_many :historical_person_areas
  has_many :historical_people, through: :historical_person_areas
  has_many :historical_location_areas
  has_many :managers, -> {
    where('historical_person_areas.manages = true')
  }, class_name: HistoricalPerson, source: :historical_person, through: :historical_person_areas
  has_many :non_managers, -> {
    where('historical_person_areas.manages = false')
  }, class_name: HistoricalPerson, source: :historical_person, through: :historical_person_areas
  has_many :historical_locations, through: :historical_location_areas

  validates :date, presence: true
  validates :name, presence: true, length: { minimum: 3 }
  validates :area_type, presence: true

  delegate :client, to: :project
end
