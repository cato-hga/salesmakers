require 'rails_helper'

describe TextPostsController do
  let(:text_post) { build :text_post }
  let(:wall) { create :person_wall }

  describe 'POST create' do
    it 'creates a new text post' do
      expect {
        post :create,
             text_post: text_post.attributes.merge(wall_id: wall.id)
      }.to change(TextPost, :count).by(1) # This is changed from 3 to 1. I believe that we always thought it was weird that
                                          # the text post was increased by 3
      expect(response).to be_success
      expect(response).to render_template(:show)
    end
  end
end