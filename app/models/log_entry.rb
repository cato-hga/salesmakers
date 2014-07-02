class LogEntry < ActiveRecord::Base

  validates :person, presence: true
  validates :action, presence: true
  validates :trackable, presence: true

  belongs_to :person
  belongs_to :trackable, polymorphic: true
  belongs_to :referenceable, polymorphic: true
end
