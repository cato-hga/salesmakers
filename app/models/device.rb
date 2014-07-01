class Device < ActiveRecord::Base

  validates :serial, presence: true, length: { minimum: 6 }
  validates :identifier, presence: true, length:  { minimum: 4 }
  validates :device_model, presence: true

  belongs_to :device_model
  belongs_to :line
  belongs_to :person
  has_and_belongs_to_many :device_states
end
