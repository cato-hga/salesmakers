class CommunicationLogEntry < ActiveRecord::Base
  validates :loggable, presence: true
  validates :person, presence: true

  belongs_to :loggable, polymorphic: true
  belongs_to :person

  default_scope { order(created_at: :desc) }
end
