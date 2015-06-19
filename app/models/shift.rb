# == Schema Information
#
# Table name: shifts
#
#  id          :integer          not null, primary key
#  person_id   :integer          not null
#  location_id :integer
#  date        :date             not null
#  hours       :decimal(, )      not null
#  break_hours :decimal(, )      default(0.0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Shift < ActiveRecord::Base
  validates :person, presence: true
  validates :date, presence: true
  validates :hours, presence: true

  belongs_to :person
  belongs_to :location
end
