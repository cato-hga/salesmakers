require 'rails_helper'

describe UploadedImagesController do
  let(:uploaded_image) { build :uploaded_image }
  let(:image_file) { fixture_file_upload("#{::Rails.root}/spec/fixtures/files/image.jpg", 'image/jpeg') }
  let(:wall) { create :person_wall }

  describe 'POST create' do
    it 'creates an uploaded image' do
      expect {
        post :create,
             uploaded_image: uploaded_image.attributes.
                 merge(image: image_file,
                       wall_id: wall.id)
      }.to change(UploadedImage, :count).by(1)
      expect(response).to be_success
      expect(response).to render_template(:show)
    end
  end
end