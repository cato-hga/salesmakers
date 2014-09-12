class UploadedImagesController < ApplicationController
  def create
  end

  private

  def uploaded_image_params
    params.require(:uploaded_image).permit(:image)
  end
end
