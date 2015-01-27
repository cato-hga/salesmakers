# class PollQuestionsController < ApplicationController
#   layout false, only: :show
#   after_action :verify_authorized, except: :show
#
#   def new
#     authorize PollQuestion.new
#     @poll_question = PollQuestion.new
#   end
#
#   def create
#     authorize PollQuestion.new
#     @poll_question = PollQuestion.new poll_question_params
#     if @poll_question.save
#       redirect_to poll_questions_path
#     else
#       render :new
#     end
#   end
#
#   def index
#     authorize PollQuestion.new
#     @poll_questions = PollQuestion.all
#     @poll_question_choice = PollQuestionChoice.new
#   end
#
#   def show
#     @poll_question = PollQuestion.find params[:id]
#   end
#
#   def edit
#     @poll_question = PollQuestion.find params[:id]
#     authorize @poll_question
#   end
#
#   def update
#     @poll_question = PollQuestion.find params[:id]
#     authorize @poll_question
#     if @poll_question.update poll_question_params
#       flash[:notice] = 'The poll question has been saved.'
#       redirect_to poll_questions_path
#     else
#       render :edit
#     end
#   end
#
#   def destroy
#     @poll_question = PollQuestion.find params[:id]
#     authorize @poll_question
#     if @poll_question.destroy
#       flash[:notice] = 'Poll question successfully deleted.'
#     else
#       flash[:error] = 'Could not delete the poll question.'
#     end
#     redirect_to poll_questions_path
#   end
#
#   private
#
#     def poll_question_params
#       params.require(:poll_question).permit :question,
#                                             :help_text,
#                                             :start_time,
#                                             :start_time_text,
#                                             :end_time,
#                                             :end_time_text,
#                                             :active
#     end
#
# end