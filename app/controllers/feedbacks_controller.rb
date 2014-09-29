class FeedbacksController < ApplicationController

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new params[:feedback]
    @feedback.request = request
    if @feedback.deliver
      flash.now[:notice] = 'Thank you for your feedback!'
    else
      flash.now[:error] = 'Cannot send message! Please email development@retaildoneright.com with your feedback.'
      render :new
    end
  end
end