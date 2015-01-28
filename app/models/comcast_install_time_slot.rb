class ComcastInstallTimeSlot < ActiveRecord::Base
  validates :name, length: { minimum: 2 }

  default_scope { order :name }
end