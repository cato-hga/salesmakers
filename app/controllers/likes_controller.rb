# class LikesController < ApplicationController
#   def create
#     like = Like.find_or_initialize_by wall_post_id: params[:wall_post_id], person: @current_person
#     if like.save
#       render text: params[:wall_post_id].to_s
#     else
#       render text: '', status: :bad_request
#     end
#   end
#
#   def destroy
#     like = Like.find_by wall_post_id: params[:wall_post_id], person: @current_person
#     if like.destroy
#       render text: params[:wall_post_id].to_s
#     else
#       render text: '', status: :bad_request
#     end
#   end
#
# end
