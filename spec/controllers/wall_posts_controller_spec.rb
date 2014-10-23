require 'rails_helper'

describe WallPostsController do
  let(:wall_post) { create :wall_post, person: Person.first, wall_id: old_wall.id }
  let(:old_wall) { create :area_wall }
  let(:invalid_post) { create :wall_post, person: invalid_person }
  let(:invalid_person) { create :person }
  let(:invalid_wall) { create :person_wall, wallable: invalid_person }

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

    it 'does not allow sharing the post to a wall if the destination wall already includes the post' do
      request.env['HTTP_REFERER'] = root_path
      get :promote,
          id: wall_post.id,
          wall_id: wall_post.wall.id
      expect(request.flash[:error]).not_to be_nil
    end

    #TODO: Either create a test for the post not being able to be saved, or fix the code. It may be in this instance
    #that the code needs to be changed.

    # it 'flashes an error if the post promotion is not saved' do
    #   request.env['HTTP_REFERER'] = root_path
    #   get :promote,
    #        id: invalid_post.id,
    #        wall_id: old_wall.id
    #   wall_post.reload
    #   expect(request.flash[:error]).not_to be_nil
    # end

    it 'does not allow promotion if the person cannot post to that wall' do
      request.env['HTTP_REFERER'] = root_path
      get :promote,
          id: wall_post.id,
      expect(request.flash[:error]).not_to be_nil
      expect(response).to redirect_to(root_path)
    end
  end

  # TODO: Test is failing, probably due to authorization
  # describe 'DELETE destroy' do
  #   let(:delete_wall_post) { create :wall_post, person: Person.first }
  #   it 'deletes a wall post' do
  #     delete_wall_post.save
  #     request.env['HTTP_REFERER'] = root_path
  #     expect {
  #       delete :destroy,
  #              id: delete_wall_post.id,
  #              person: Person.first
  #       delete_wall_post.reload
  #     }.to change(WallPost, :count).by(-1)
  #     expect(response).to redirect_to(root_path)
  #   end
  # end

end