class CandidateNote < ActiveRecord::Base
  validates :candidate, presence: true
  validates :person, presence: true
  validates :note, length: { minimum: 5 }

  belongs_to :candidate
  belongs_to :person

  default_scope { order created_at: :desc }
end
