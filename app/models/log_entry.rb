class LogEntry < ActiveRecord::Base
  before_validation :set_default_person

  validates :person, presence: true
  validates :action, presence: true
  validates :trackable, presence: true

  belongs_to :person
  belongs_to :trackable, polymorphic: true
  belongs_to :referenceable, polymorphic: true

  default_scope { order('created_at DESC') }

  private

  def set_default_person
    self.person = Person.find_by email: 'retailingw@retaildoneright.com' unless self.person
  end
end
