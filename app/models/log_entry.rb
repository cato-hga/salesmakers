class LogEntry < ActiveRecord::Base
  before_validation :set_default_person

  validates :person, presence: true
  validates :action, presence: true
  validates :trackable, presence: true

  belongs_to :person
  belongs_to :trackable, polymorphic: true
  belongs_to :referenceable, polymorphic: true

  default_scope { order('created_at DESC') }

  def self.person_onboarded_from_connect(person, creator, created = nil, updated = nil)
    return unless person and creator and person.valid? and creator.valid?
    entry = self.new action: 'create',
                     trackable: person,
                     person: creator
    entry.created_at = created if created
    entry.updated_at = updated if updated
    entry.save
  end

  def self.person_separated_from_connect(person, separator, separated_at = nil)
    return unless person and separator and person.valid? and separator.valid?
    entry = self.new action: 'separate',
                     trackable: person,
                     person: separator
    if separated_at
      entry.created_at = separated_at
      entry.updated_at = separated_at
    end
    entry.save
  end

  def self.position_set_from_connect(person, creator, position, created = nil, updated = nil)
    return unless person and creator and position and person.valid? and creator.valid? and position.valid?
    entry = self.new action: 'set_position',
                     trackable: person,
                     referenceable: position,
                     person: creator
    entry.created_at = created if created
    entry.updated_at = updated if updated
    entry.save
  end

  def self.assign_as_manager_from_connect(person, creator, area, created = nil, updated = nil)
    return unless person and creator and area and person.valid? and creator.valid? and area.valid?
    assign_to_area_from_connect 'assign_as_manager', person, creator, area, created, updated
  end

  def self.assign_as_employee_from_connect(person, creator, area, created = nil, updated = nil)
    return unless person and creator and area and person.valid? and creator.valid? and area.valid?
    assign_to_area_from_connect 'assign_as_employee', person, creator, area, created, updated
  end

  def self.assign_to_area_from_connect(action, person, creator, area, created = nil, updated = nil)
    return unless action and person and creator and area and person.valid? and creator.valid? and area.valid?
    entry = LogEntry.new action: action,
                         trackable: person,
                         referenceable: area,
                         person: creator
    entry.created_at = created if created
    entry.updated_at = updated if updated
    entry.save
  end

  private

  def set_default_person
    self.person = Person.find_by email: 'retailingw@retaildoneright.com' unless self.person
  end

end
