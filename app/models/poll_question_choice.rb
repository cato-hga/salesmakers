class PollQuestionChoice < ActiveRecord::Base
  validates :poll_question, presence: true
  validates :name, length: { minimum: 2 }

  belongs_to :poll_question
  has_and_belongs_to_many :people
end
