# == Schema Information
#
# Table name: directv_install_time_slots
#
#  id         :integer          not null, primary key
#  active     :boolean          default(TRUE), not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DirecTVInstallTimeSlot < ActiveRecord::Base
  validates :name, length: { minimum: 2 }

  default_scope { order :created_at }

  strip_attributes
end
