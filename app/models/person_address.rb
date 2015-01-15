class PersonAddress < ActiveRecord::Base
  states = Array[ "AK", "AL", "AR", "AS", "AZ", "CA", "CO",
                  "CT", "DC", "DE", "FL", "GA", "GU", "HI",
                  "IA", "ID", "IL", "IN", "KS", "KY", "LA",
                  "MA", "MD", "ME", "MI", "MN", "MO", "MS",
                  "MT", "NC", "ND", "NE", "NH", "NJ", "NM",
                  "NV", "NY", "OH", "OK", "OR", "PA", "PR",
                  "RI", "SC", "SD", "TN", "TX", "UT", "VA",
                  "VI", "VT", "WA", "WI", "WV", "WY" ]

  validates :person, presence: true
  validates :line_1, format: { with: /\A\d\d+[A-Za-z]? .{2,}\z/, message: 'must be a valid street address' }
  validates :city, length: { minimum: 2 }
  validates :state, length: { is: 2 }, inclusion: { in: states }
  validates :zip, format: { with: /\A\d{5}\z/, message: 'must be 5 digits' }

  belongs_to :person

  def state=(value)
    unless value
      self[:state] = value
      return
    end
    self[:state] = value.upcase
  end
end
