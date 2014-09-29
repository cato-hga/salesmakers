class LinkPostsController < ApplicationController
  layout false

  def create
    @link_post = LinkPost.new link_post_params
    @link_post.person = @current_person
    wall_id = params.require(:link_post).permit(:wall_id).first[1] if params.require(:link_post).permit(:wall_id).first
    if @link_post.save
      @wall_post = @link_post.create_wall_post Wall.find(wall_id), @current_person
      render :show
    else
      @object = @link_post
      render partial: 'shared/ajax_errors', status: :unprocessable_entity
    end
  end

  private

  def link_post_params
    params.require(:link_post).permit(:url)
  end
end
