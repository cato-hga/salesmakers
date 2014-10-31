require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe GroupMeGroup, :type => :model do

  it { should have_and_belong_to_many(:group_me_users) }
  it { should belong_to(:area) }
  it { should have_many(:group_me_posts) }

  it 'should update groups if GroupMeGroup is found', :vcr do
    @groups = GroupMeGroup.update_group('8936279') #TODO: Should this be hardcoded?
    expect(@groups).to_not be_nil #TODO: << This sucks.
  end

  it 'should return nil if GroupMeGroup is not found', :vcr do
    @groups = GroupMeGroup.update_group('111111')
    expect(@groups).to be_nil #TODO: << This probably sucks even more
  end

  #TODO: Mock this out
  # describe 'likes thresholds' do
  #
  #   it 'should return 4 if member count is under 10' do
  #     likes = 5
  #     expect(GroupMeGroup.likes_threshold).to eq('4')
  #   end
  #
  # end

end
