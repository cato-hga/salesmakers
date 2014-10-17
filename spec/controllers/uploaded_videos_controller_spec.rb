require 'rails_helper'

describe UploadedVideosController do
  let(:uploaded_video) { build :uploaded_video }
  let(:wall) { create :person_wall }

  describe 'POST create' do
    it 'creates an uploaded video' do
      expect {
        post :create,
             uploaded_video: uploaded_video.attributes.
                 merge(wall_id: wall.id)
      }.to change(UploadedVideo, :count).by(1)
      expect(response).to be_success
      expect(response).to render_template(:show)
    end
  end
end