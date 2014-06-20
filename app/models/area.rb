class Area < ActiveRecord::Base

  validates :name, presence: true, length: { minimum: 3 }
  validates :area_type, presence: true

  belongs_to :area_type
end
