class HomeController < ApplicationController
  def index
    @wall_posts = WallPost.visible(@current_person).page(params[:page])
  end

  def dashboard
  end

end
