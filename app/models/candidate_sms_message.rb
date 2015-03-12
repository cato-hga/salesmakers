class CandidateSMSMessage < ActiveRecord::Base

  validates :text, presence: true, length: {maximum: 160}
end
