class CandidateSource < ActiveRecord::Base

  validates :name, presence: true
end
