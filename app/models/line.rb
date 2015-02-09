class Line < ActiveRecord::Base
  before_save :strip_non_alphanumeric

  validates :identifier, presence: true, length: {is: 10}, uniqueness: {case_sensitive: false}
  validates :contract_end_date, presence: true
  validates :technology_service_provider, presence: true

  belongs_to :technology_service_provider
  has_and_belongs_to_many :line_states

  has_one :device

  ransacker :unstripped_identifier, formatter: proc { |v| v.strip.gsub /[^0-9]/, '' } do |parent|
    parent.table[:identifier]
  end

  def active?
    active_state = LineState.find_or_initialize_by name: 'Active'
    self.line_states.include? active_state
  end

  def identifier=(identifier)
    self[:identifier] = identifier
    strip_non_alphanumeric
  end

  private

  def strip_non_alphanumeric
    return if not self.identifier
    self[:identifier] = self.identifier.gsub(/[^0-9A-Za-z]/, '')
  end
end
