class EmailMessage < ActiveRecord::Base
  validates :from_email, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/, message: 'must be a valid email address' }
  validates :to_email, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/, message: 'must be a valid email address' }
  validates :content, presence: true

  belongs_to :to_person, class_name: 'Person', foreign_key: 'to_person_id'

  def from_email=(value)
    return unless value
    self[:from_email] = value.downcase!
  end

  def to_email=(value)
    return unless value
    self[:to_email] = value.downcase!
    email_person = Person.find_by email: value
    personal_email_person = Person.find_by personal_email: value
    self.to_person = email_person
    self.to_person = personal_email_person if personal_email_person
  end
end
