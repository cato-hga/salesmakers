# class LinkPostsController < ApplicationController
#   layout false
#
#   def create
#     @link_post = LinkPost.new person: @current_person,
#                               url: LinkPost.linkify(link_post_params[:url])
#     wall_id = params.require(:link_post).permit(:wall_id).first[1] if params.require(:link_post).permit(:wall_id).first
#     if @link_post.save
#       @wall_post = @link_post.create_wall_post Wall.find(wall_id), @current_person
#       render :show
#     else
#       render partial: 'shared/ajax_errors', status: :unprocessable_entity, locals: { object: @link_post }
#     end
#   end
#
#   def show
#     @link_post = LinkPost.find params[:id]
#   end
#
#   private
#
#   def link_post_params
#     params.require(:link_post).permit(:url)
#   end
# end
