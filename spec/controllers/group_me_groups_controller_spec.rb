require 'rails_helper'

describe GroupMeGroupsController do
  let(:person) { create :person }
  let(:permission) { create :permission, key: 'group_me_group_post' }
  let(:group_me_group) { create :group_me_group, group_num: '8936279' }
  let!(:second_group_me_group) { create :group_me_group, group_num: '12548729' }

  before do
    person.position.permissions << permission
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  describe 'GET new_post' do
    before { get :new_post }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new_post template' do
      expect(response).to render_template(:new_post)
    end
  end

  describe 'POST post' do
    before do
      post :post,
           group_me_group_ids: [
               group_me_group.id.to_s,
               second_group_me_group.id.to_s
           ],
           message: 'This is a test message.'
    end

    it 'redirects to new_post', :vcr do
      expect(response).to redirect_to(new_post_group_me_groups_path)
    end
  end
end