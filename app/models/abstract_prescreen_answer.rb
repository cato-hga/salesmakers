class AbstractPrescreenAnswer < ActiveRecord::Base
  validates :candidate, presence: true
  validates :person, presence: true
  validates :project, presence: true
  validates :answers, presence: true

  belongs_to :candidate
  belongs_to :person
  belongs_to :project
end
