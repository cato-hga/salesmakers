require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe GroupMePost, :type => :model do

  it { should belong_to(:group_me_user) }
  it { should belong_to(:group_me_group) }
  it { should have_many(:group_me_likes) }
  it { should belong_to(:person) }

  describe 'set_person callback' do
    let(:person) { create :person }
    let(:group_me_user) { create :group_me_user, person: person }
    let(:group_me_post) { create :group_me_post, group_me_user: group_me_user }

    it 'should set the person to a group_me_user' do
      expect(group_me_post.person).to be(person)
    end
  end
end
