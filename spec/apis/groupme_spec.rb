require 'rails_helper'
require 'apis/groupme'

describe 'GroupMe API' do

  before(:all) do
    @groupme = GroupMe.new('7a853610f0ca01310e5a065d7b71239d')
  end

  it 'should get a list of groups' do
    groups = @groupme.get_groups
    expect(groups.response.code).to eq('200')
  end

  it 'should return at least one group' do
    group = @groupme.get_group '8936279'
    expect(group).to_not be_nil
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

  it 'should get images' do
    messages = @groupme.get_images
    expect(messages.count).to be > 0
  end

  it 'should get the RBD IT account (AKA: Me)' do
    me = @groupme.get_me
    expect(me['id']).to eq('12486363')
  end

  # TODO: Test text message sending
  # it 'should be able to send a text message' do
  #   message = @groupme.send_message('8936279', 'GroupMe API "send_message" test')
  #   expect(message['message']['text']).to eq('201')
  # end
end
