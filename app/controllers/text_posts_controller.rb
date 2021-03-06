# class TextPostsController < ApplicationController
#   layout false
#
#   def create
#     @text_post = TextPost.new text_post_params
#     @text_post.person = @current_person
#     wall_id = params.require(:text_post).permit(:wall_id).first[1] if params.require(:text_post).permit(:wall_id).first
#     if @text_post.save
#       @wall_post = @text_post.create_wall_post Wall.find(wall_id), @current_person
#       render :show
#     else
#       render partial: 'shared/ajax_errors', status: :unprocessable_entity, locals: { object: @text_post }
#     end
#   end
#
#   def show
#     @text_post = TextPost.find params[:id]
#   end
#
#   private
#
#   def text_post_params
#     params.require(:text_post).permit(:content)
#   end
# end
