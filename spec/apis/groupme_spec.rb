require 'rails_helper'
require 'apis/groupme'

describe 'GroupMe API' do
  let(:groupme) { GroupMe.new('7a853610f0ca01310e5a065d7b71239d') }

  it 'should get a list of groups', :vcr do
    groups = groupme.get_groups
    expect(groups.response.code).to eq('200')
  end

  it 'should return at least one group', :vcr do
    group = groupme.get_group '8936279'
    expect(group).to_not be_nil
  end

  it 'should get a list of messages from groups', :vcr do
    groups = groupme.get_groups
    group_id = groups['response'][0]['group_id']
    messages = groupme.get_messages group_id
    expect(messages.count).to be > 0
  end

  it 'should get a list of recent messages', :vcr do
    messages = groupme.get_recent_messages
    expect(messages.count).to be > 0
  end

  it 'should display recent messages over the minimum likes threshold', :vcr do
    messages = groupme.get_recent_messages 5, 3
    for message in messages do
      expect(message.likes).to be >= 3
    end
  end

  it 'should get images', :vcr do
    messages = groupme.get_images
    expect(messages.count).to be > 0
  end

  it 'should get the RBD IT account (AKA: Me)', :vcr do
    me = groupme.get_me
    expect(me['id']).to eq('12486363')
  end

  it 'should be able to send a text message', :vcr do
    message = groupme.send_message('8936279', 'GroupMe API "send_message" test')
    expect(message).not_to be_nil
  end
end
