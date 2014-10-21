class PollQuestionChoice < ActiveRecord::Base
  validates :poll_question, presence: true
  validates :name, length: { minimum: 2 }

  belongs_to :poll_question
  has_and_belongs_to_many :people

  default_scope { order :created_at }

  def answered?
    if self.people.count > 0
      return true
    end
    return false
  end

  def locked?
    answered?
  end
end
