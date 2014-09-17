class UploadedImagesController < ApplicationController
  layout false

  def create
    @uploaded_image = UploadedImage.new uploaded_image_params
    @uploaded_image.person = @current_person
    if @uploaded_image.save
      @wall_post = @uploaded_image.create_wall_post Wall.find(params[:wall_id]), @current_person
    end
    render :show
  end

  private

  def uploaded_image_params
    params.require(:uploaded_image).permit(:image, :caption)
  end
end
