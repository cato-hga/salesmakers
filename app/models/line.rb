class Line < ActiveRecord::Base
  before_save :strip_non_alphanumeric

  validates :identifier, presence: true, length: {minimum: 10}, uniqueness: {case_sensitive: false}
  validates :contract_end_date, presence: true
  validates :technology_service_provider, presence: true

  belongs_to :technology_service_provider
  has_and_belongs_to_many :line_states

  private

  def strip_non_alphanumeric
    return if not self.identifier
    self.identifier = self.identifier.gsub(/[^0-9A-Za-z]/, '')
  end
end
