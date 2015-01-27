# class UploadedVideosController < ApplicationController
#   layout false
#
#   def create
#     @uploaded_video = UploadedVideo.new uploaded_video_params
#     @uploaded_video.person = @current_person
#     wall_id = params.require(:uploaded_video).permit(:wall_id).first[1] if params.require(:uploaded_video).permit(:wall_id).first
#     if @uploaded_video.save
#       @wall_post = @uploaded_video.create_wall_post Wall.find(wall_id), @current_person
#     end
#     render :show
#   end
#
#   def show
#     @uploaded_video = UploadedVideo.find params[:id]
#   end
#
#   private
#
#   def uploaded_video_params
#     params.require(:uploaded_video).permit(:url)
#   end
# end
