class PollQuestionChoicesController < ApplicationController
  after_action :verify_authorized, except: :choose

  def create
    authorize PollQuestion.new
    @poll_question_choice = PollQuestionChoice.new poll_question_choice_params
    @poll_question_choice.poll_question_id = params[:poll_question_id]
    if @poll_question_choice.save
      render @poll_question_choice
    else
      @object = @poll_question_choice
      render partial: 'shared/ajax_errors', status: :bad_request
    end
  end

  def update
    @poll_question_choice = PollQuestionChoice.find params[:id]
    authorize @poll_question_choice.poll_question
    if @poll_question_choice.locked?
      flash[:error] = 'The choice you are attempting to edit has ' +
          'already been answered and cannot be edited.'
      redirect_to poll_questions_path and return
    end
    if @poll_question_choice.update poll_question_choice_params
      render @poll_question_choice
    else
      @object = @poll_question_choice
      render partial: 'shared/ajax_errors', status: :bad_request
    end
  end

  def destroy
    @poll_question_choice = PollQuestionChoice.find params[:id]
    authorize @poll_question_choice.poll_question
    if not @poll_question_choice.locked? and @poll_question_choice.destroy
      flash[:notice] = 'Poll question choice deleted.'
    else
      flash[:error] = 'Could not delete poll question choice.'
    end
    redirect_to poll_questions_path
  end

  def choose
    @poll_question_choice = PollQuestionChoice.find params[:id]
    @poll_question = PollQuestion.find params[:poll_question_id]
    unless @poll_question.answered_by?(@current_person)
      @poll_question_choice.people << @current_person
    end
    redirect_to poll_question_path(@poll_question)
  end

  private

    def poll_question_choice_params
      params.require(:poll_question_choice).permit :poll_question_id,
                                                   :name,
                                                   :help_text

    end

end