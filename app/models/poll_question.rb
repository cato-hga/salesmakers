class PollQuestion < ActiveRecord::Base
  validates :question, length: { minimum: 15 }
  validates :start_time, presence: true
  validate :start_time_after_beginning_of_today
  validate :end_time_before_now
  validate :end_time_after_start_time

  has_many :poll_question_choices

  normalize_attributes :help_text

  scope :active, -> {
    where('start_time <= ? AND (end_time >= ? OR end_time IS NULL) AND active = ?',
          Time.now,
          Time.now,
          true)
  }

  scope :visible, ->(person = nil) {
    return PollQuestion.none unless person
    visible_questions = Array.new
    active.each do |poll_question|
      visible_questions << poll_question unless
          poll_question.answered_by?(person)
    end
    return active.none if visible_questions.count < 1
    active.where("\"poll_questions\".\"id\" IN (#{visible_questions.map(&:id).join(',')})")
  }

  # Not currently being used

  # def start_time_text
  #   if start_time
  #     start_time.strftime('%m/%d/%Y %l:%M%P')
  #   else
  #     Time.now.strftime('%m/%d/%Y %l:%M%P')
  #   end
  # end
  #
  # def end_time_text
  #   if end_time
  #     end_time.strftime('%m/%d/%Y %l:%M%P')
  #   else
  #     ''
  #   end
  # end

  def start_time_text=(text)
    self.start_time = Chronic.parse(text)
  end

  def end_time_text=(text)
    self.end_time = Chronic.parse(text)
  end

  def locked?
    answered?
  end

  def answered?
    for poll_question_choice in self.poll_question_choices do
      return true if poll_question_choice.answered?
    end
    false
  end

  def answered_by?(person)
    for poll_question_choice in self.poll_question_choices do
      return true if poll_question_choice.answered_by?(person)
    end
    false
  end

  def answers
    answers = 0
    for poll_question_choice in self.poll_question_choices do
      answers += poll_question_choice.answers
    end
    answers
  end

  private

  def start_time_after_beginning_of_today
    return unless start_time
    return unless new_record?
    beginning_of_day = Time.now.beginning_of_day
    if start_time < beginning_of_day
      errors.add :start_time, 'cannot be before today'
    end
  end

  def end_time_before_now
    return unless end_time
    if end_time < Time.now
      errors.add :end_time, 'cannot be in the past'
    end
  end

  def end_time_after_start_time
    return unless end_time and start_time
    if end_time < start_time
      errors.add :end_time, 'cannot be before start time'
    end
  end
end
