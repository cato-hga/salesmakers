# == Schema Information
#
# Table name: candidate_contacts
#
#  id             :integer          not null, primary key
#  contact_method :integer          not null
#  inbound        :boolean          default(FALSE), not null
#  person_id      :integer          not null
#  candidate_id   :integer          not null
#  notes          :text             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  call_results   :text
#

class CandidateContact < ActiveRecord::Base
  enum contact_method: [
           :sms,
           :phone,
           :email,
           :video,
           :google_chat,
           :group_me,
           :snail_mail
       ]

  validates :contact_method, presence: true, inclusion: { in: CandidateContact.contact_methods.keys }
  validates :person, presence: true
  validates :candidate, presence: true
  validates :notes, length: { minimum: 10 }

  belongs_to :candidate
  belongs_to :person

  default_scope { order(created_at: :desc) }
end
