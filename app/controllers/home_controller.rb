class HomeController < ApplicationController
  def index
    setup_new_publishables
    @wall_posts = WallPost.where wall: @wall

  end

  def dashboard

  end

end
