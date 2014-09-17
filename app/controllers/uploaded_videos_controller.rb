class UploadedVideosController < ApplicationController
  layout false

  def create
    @uploaded_video = UploadedVideo.new uploaded_video_params
    @uploaded_video.person = @current_person
    if @uploaded_video.save
      @wall_post = @uploaded_video.create_wall_post Wall.find(params[:wall_id]), @current_person
    end
    render :show
  end

  private

  def uploaded_video_params
    params.require(:uploaded_video).permit(:url)
  end
end
