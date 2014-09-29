class FeedbacksController < ApplicationController

  layout false

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new params[:feedback]
    @feedback.request = request
    if @feedback.deliver
      flash[:notice] = 'Thank you for your feedback!'
      redirect_to :back
    else
      flash[:error] = 'Cannot send message! Please email development@retaildoneright.com with your feedback.'
      redirect_to :back
    end
  end
end