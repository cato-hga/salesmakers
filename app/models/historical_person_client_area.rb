# == Schema Information
#
# Table name: historical_person_client_areas
#
#  id                        :integer          not null, primary key
#  historical_person_id      :integer          not null
#  historical_client_area_id :integer          not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  date                      :date             not null
#

class HistoricalPersonClientArea < ActiveRecord::Base
  validates :date, presence: true
  validates :historical_person, presence: true
  validates :historical_client_area, presence: true

  belongs_to :historical_person
  belongs_to :historical_client_area

  delegate :project, to: :historical_client_area
  delegate :client, to: :historical_client_area
end
