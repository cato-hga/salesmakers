class PollQuestionsController < ApplicationController

  def create
    @poll_question = PollQuestion.new poll_question_params
    if @poll_question.save
      redirect_to poll_questions_path
    else
      flash[:error] = 'Could not save the new poll question.'
      redirect_to :back
    end
  end

  private

  def poll_question_params
    params.require(:poll_question).permit :question,
                                          :help_text,
                                          :start_time,
                                          :end_time,
                                          :active
  end

end