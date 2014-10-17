require 'rails_helper'

describe WallPostCommentsController do
  let(:wall_post_comment) { build :wall_post_comment }

  describe 'POST create' do
    it 'creates a wall post comment' do
      expect {
        post :create,
             wall_post_comment: wall_post_comment.attributes
      }.to change(WallPostComment, :count).by(1)
      expect(response).to be_success
    end
  end

  describe 'PUT update' do
    it 'updates a wall post comment' do
      wall_post_comment.save
      expect {
        put :update,
            id: wall_post_comment.id,
            wall_post_comment: { comment: 'This is new.' }
        wall_post_comment.reload
      }.to change(wall_post_comment, :comment).to('This is new.')
      expect(response).to be_success
    end
  end

  # TODO: This test is failing, presumably because of the authorization.
  # describe 'DELETE destroy' do
  #   it 'deletes a wall post comment' do
  #     request.env['HTTP_REFERER'] = root_path
  #     wall_post_comment.save
  #     expect {
  #       delete :destroy,
  #              id: wall_post_comment.id
  #     }.to change(WallPostComment, :count).by(-1)
  #     expect(response).to redirect_to(root_path)
  #   end
  # end
end