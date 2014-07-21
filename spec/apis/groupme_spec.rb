require 'rails_helper'
require 'apis/groupme'

describe 'GroupMe API' do

  before(:all) do
    @groupme = GroupMe.new
  end

  it 'should get a list of groups' do
    groups = @groupme.get_groups
    expect(groups.response.code).to eq('200')
  end

  it 'should return at least one group' do
    groups = @groupme.get_groups
    expect(groups['response'].count).to be > 0
  end

  it 'should get a list of messages from groups' do
    groups = @groupme.get_groups
    group_id = groups['response'][0]['group_id']
    messages = @groupme.get_messages group_id
    expect(messages.count).to be > 0
  end

  it 'should get a list of recent messages' do
    messages = @groupme.get_recent_messages
    expect(messages.count).to be > 0
  end

  it 'should display recent messages over the minimum likes threshold' do
    messages = @groupme.get_recent_messages 5, 3
    for message in messages do
      expect(message.likes).to be >= 3
    end
  end



end
