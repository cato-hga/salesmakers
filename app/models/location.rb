class Location < ActiveRecord::Base
  states = Array[ "AK", "AL", "AR", "AS", "AZ", "CA", "CO",
                  "CT", "DC", "DE", "FL", "GA", "GU", "HI",
                  "IA", "ID", "IL", "IN", "KS", "KY", "LA",
                  "MA", "MD", "ME", "MI", "MN", "MO", "MS",
                  "MT", "NC", "ND", "NE", "NH", "NJ", "NM",
                  "NV", "NY", "OH", "OK", "OR", "PA", "PR",
                  "RI", "SC", "SD", "TN", "TX", "UT", "VA",
                  "VI", "VT", "WA", "WI", "WV", "WY" ]

  validates :store_number, presence: true
  validates :city, length: { minimum: 2 }
  validates :state, inclusion: { in: states }
  validates :channel, presence: true

  belongs_to :channel
  has_and_belongs_to_many :areas
end
