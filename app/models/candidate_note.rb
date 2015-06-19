# == Schema Information
#
# Table name: candidate_notes
#
#  id           :integer          not null, primary key
#  candidate_id :integer          not null
#  person_id    :integer          not null
#  note         :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CandidateNote < ActiveRecord::Base
  validates :candidate, presence: true
  validates :person, presence: true
  validates :note, length: { minimum: 5 }

  belongs_to :candidate
  belongs_to :person

  default_scope { order created_at: :desc }
end
