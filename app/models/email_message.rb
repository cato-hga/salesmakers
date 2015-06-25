# == Schema Information
#
# Table name: email_messages
#
#  id           :integer          not null, primary key
#  from_email   :string           not null
#  to_email     :string           not null
#  to_person_id :integer
#  content      :text             not null
#  created_at   :datetime
#  updated_at   :datetime
#  subject      :string           not null
#

class EmailMessage < ActiveRecord::Base
  after_create :create_communication_log_entry

  validates :from_email, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/, message: 'must be a valid email address' }
  validates :to_email, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/, message: 'must be a valid email address' }
  validates :subject, presence: true
  validates :content, presence: true

  belongs_to :to_person, class_name: 'Person', foreign_key: 'to_person_id'

  def from_email=(value)
    unless value
      self[:from_email] = value
      return
    end
    self[:from_email] = value.downcase
  end

  def to_email=(value)
    unless value
      self[:to_email] = value
      return
    end
    self[:to_email] = value.downcase
    email_person = Person.find_by email: value
    personal_email_person = Person.find_by personal_email: value
    self.to_person = personal_email_person
    self.to_person = email_person if email_person
  end

  private

  def create_communication_log_entry
    if self.to_person
      CommunicationLogEntry.create loggable: self,
                                   person: self.to_person
    end
  end
end
