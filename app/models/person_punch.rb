# == Schema Information
#
# Table name: person_punches
#
#  id         :integer          not null, primary key
#  identifier :string           not null
#  punch_time :datetime         not null
#  in_or_out  :integer          not null
#  person_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PersonPunch < ActiveRecord::Base
  validates :identifier, presence: true
  validates :punch_time, presence: true
  validates :in_or_out, presence: true

  belongs_to :person

  enum in_or_out: [:in, :out]

  strip_attributes
end
