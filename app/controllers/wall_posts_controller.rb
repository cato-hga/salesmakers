class WallPostsController < ApplicationController
  def promote
  end


  def destroy
    @wall_post = WallPost.find params[:id]
    authorize @wall_post
    if @wall_post.destroy
      flash[:notice] = 'Post deleted'
      redirect_to :back
    else
      flash[:error] = 'Post could NOT be deleted!'
    end
  end
end
