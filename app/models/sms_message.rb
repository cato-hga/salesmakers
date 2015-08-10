# == Schema Information
#
# Table name: sms_messages
#
#  id                      :integer          not null, primary key
#  from_num                :string           not null
#  to_num                  :string           not null
#  from_person_id          :integer
#  to_person_id            :integer
#  inbound                 :boolean          default(FALSE)
#  reply_to_sms_message_id :integer
#  replied_to              :boolean          default(FALSE)
#  message                 :text             not null
#  created_at              :datetime
#  updated_at              :datetime
#  sid                     :string           not null
#  from_candidate_id       :integer
#  to_candidate_id         :integer
#

class SMSMessage < ActiveRecord::Base
  after_create :create_communication_log_entry
  validates :from_num, length: { is: 10 }
  validates :to_num, length: { is: 10 }
  validates :message, presence: true
  validates :sid, presence: true

  belongs_to :to_person, class_name: 'Person', foreign_key: 'to_person_id'
  belongs_to :from_person, class_name: 'Person', foreign_key: 'from_person_id'
  belongs_to :to_candidate, class_name: 'Candidate', foreign_key: 'to_candidate_id'
  belongs_to :from_candidate, class_name: 'Candidate', foreign_key: 'from_candidate_id'

  default_scope { order(created_at: :desc) }

  private

  def create_communication_log_entry
    if self.to_person
      CommunicationLogEntry.create loggable: self,
                                   person: self.to_person
    end
    if self.from_person
      CommunicationLogEntry.create loggable: self,
                                   person: self.from_person
    end
  end
end
