class PersonArea < ActiveRecord::Base
  validates :person, presence: true
  validates :area, presence: true

  belongs_to :person
  belongs_to :area
end
