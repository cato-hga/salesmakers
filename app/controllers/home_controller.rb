class HomeController < ApplicationController
  def index
    @wall_posts = WallPost.where(wall: @wall).page(params[:page])
    #TODO: Policy scope for wall_posts
  end

  def dashboard

  end

end
