class Line < ActiveRecord::Base

  validates :identifier, presence: true, length: { minimum: 10 }
  validates :contract_end_date, presence: true
  validates :technology_service_provider, presence: true

  belongs_to :technology_service_provider
  has_and_belongs_to_many :line_states

end
