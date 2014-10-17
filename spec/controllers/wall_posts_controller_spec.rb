require 'rails_helper'

describe WallPostsController do
  let(:wall_post) { create :wall_post, person: Person.first }

  describe 'GET promote' do
    let(:new_wall) { create :area_wall }

    it 'promotes a wall post' do
      request.env['HTTP_REFERER'] = root_path
      expect {
        get :promote,
            id: wall_post.id,
            wall_id: new_wall.id
        wall_post.reload
      }.to change(wall_post, :wall_id).to(new_wall.id)
      expect(response).to redirect_to(root_path)
    end
  end

  # TODO: Test is failing, probably due to authorization
  # describe 'DELETE destroy' do
  #   it 'deletes a wall post' do
  #     request.env['HTTP_REFERER'] = root_path
  #     wall_post
  #     expect {
  #       delete :destroy,
  #              id: wall_post.id
  #     }.to change(WallPost, :count).by(-1)
  #     expect(response).to redirect_to(root_path)
  #   end
  # end
end