class PersonPayRate < ActiveRecord::Base
  validates :person, presence: true
  validates :wage_type, presence: true
  validates :rate, presence: true, numericality: { greater_than: 7.50 }
  validates :effective_date, presence: true

  belongs_to :person

  enum wage_type: [
           :hourly,
           :salary
       ]
end