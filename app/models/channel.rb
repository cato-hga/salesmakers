class Channel < ActiveRecord::Base
  validates :name, length: { minimum: 2 }

  has_many :locations
end
