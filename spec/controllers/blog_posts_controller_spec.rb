require 'rails_helper'

describe BlogPostsController do
  let(:blog_post) { create :blog_post }

  describe 'GET index' do
    it 'returns a success status' do
      get :index
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show' do
    it 'returns a success status' do
      get :show, id: blog_post.id
      expect(response).to be_success
      expect(response).to render_template(:show)
    end

    it 'is passing the right blog post to the view' do
      get :show, id: blog_post.id
      expect(assigns(:blog_post)).to eq(blog_post)
    end
  end
end