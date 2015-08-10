# == Schema Information
#
# Table name: person_areas
#
#  id         :integer          not null, primary key
#  person_id  :integer          not null
#  area_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#  manages    :boolean          default(FALSE), not null
#

class PersonArea < ActiveRecord::Base
  validates :person, presence: true
  validates :area, presence: true

  belongs_to :person
  belongs_to :area
  has_many :log_entries, as: :trackable, dependent: :destroy


  has_paper_trail

  delegate :project, to: :area
  delegate :client, to: :area

  def self.return_from_name_and_type(person, area_name, area_type, leader = false)
    return nil unless area_type
    areas = Area.where(name: area_name, area_type: area_type)
    return nil unless areas.count > 0
    area = areas.first
    person.person_areas.new area: area,
                            manages: leader
  end
end
