class DirecTVInstallTimeSlot < ActiveRecord::Base
  validates :name, length: { minimum: 2 }

  default_scope { order :created_at }
end
