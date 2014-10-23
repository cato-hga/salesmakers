class HomeController < ApplicationController
  def index
    @wall_posts = WallPost.visible(@current_person).page(params[:page])
    @poll_questions = PollQuestion.visible(@current_person)
  end

  def dashboard
  end

end
