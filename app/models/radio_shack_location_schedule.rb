# == Schema Information
#
# Table name: radio_shack_location_schedules
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  active     :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  monday     :float            default(0.0), not null
#  tuesday    :float            default(0.0), not null
#  wednesday  :float            default(0.0), not null
#  thursday   :float            default(0.0), not null
#  friday     :float            default(0.0), not null
#  saturday   :float            default(0.0), not null
#  sunday     :float            default(0.0), not null
#

class RadioShackLocationSchedule < ActiveRecord::Base
  validates :active, presence: true
  validates :name, presence: true
  validates :monday, presence: true
  validates :tuesday, presence: true
  validates :wednesday, presence: true
  validates :thursday, presence: true
  validates :friday, presence: true
  validates :saturday, presence: true
  validates :sunday, presence: true

  has_and_belongs_to_many :location_areas
end
