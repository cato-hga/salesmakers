class HomeController < ApplicationController
  def index
    @wall_posts = WallPost.visible(@current_person).page(params[:page])
    #TODO: Policy scope for wall_posts
  end

  def dashboard

  end

end
