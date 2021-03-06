# class WallPostsController < ApplicationController
#   layout false
#
#   def promote
#     @wall_post = WallPost.find params[:id]
#     authorize @wall_post
#     @to_wall = Wall.find params[:wall_id]
#     if @to_wall == @wall_post.wall
#       flash[:error] = "This post is already posted to #{@to_wall.wallable.name}!"
#     end
#     if Wall.postable(@current_person).include? @to_wall
#       if @wall_post.repost(@to_wall, @current_person)
#         flash[:notice] = "Posted to #{@to_wall.wallable.name}."
#         redirect_to :back
#       else
#         flash[:error] = 'Post could not be updated.'
#         redirect_to :back
#       end
#     else
#       flash[:error] = 'You do not have permission to post to that wall.'
#       redirect_to :back
#     end
#   end
#
#   def destroy
#     @wall_post = WallPost.find params[:id]
#     authorize @wall_post
#     if @wall_post.destroy
#       flash[:notice] = 'Post deleted'
#       redirect_to :back
#     else
#       flash[:error] = 'Post could NOT be deleted!'
#     end
#   end
#
#   def show
#     @wall_post = WallPost.find params[:id]
#   end
# end
