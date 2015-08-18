require 'rails_helper'
require 'apis/groupme'

describe 'GroupMe API' do
  let(:groupme) { GroupMe.new_global }

  it 'should get a list of groups' do
    groups = groupme.get_groups
    expect(groups.response.code).to eq('200')
  end

  it 'should return at least one group' do
    group = groupme.get_group '8936279'
    expect(group).not_to be_nil
  end

  it 'should create a group' do
    expect {
      groupme.create_group 'TEST'
    }.to change(GroupMeGroup, :count).by(1)
  end

  # it 'should rename a group', :vcr do
  #   renamed = groupme.rename_group '12117299', 'NEW NAME'
  #   expect(renamed).to be_truthy
  # end

  describe '#get_messages' do
    it 'should get a list of messages from groups' do
      messages = groupme.get_messages "8936279"
      expect(messages.count).to be > 0
    end

    it 'should return the max messages, if max is specified' do
      messages = groupme.get_messages "8936279", max = 17
      expect(messages.count).to eq(17)
    end
  end

  describe '#get_recent_messages' do
    it 'should get a list of recent messages' do
      messages = groupme.get_recent_messages
      expect(messages.count).to be > 0
    end
  end

  it 'should get images' do
    messages = groupme.get_images
    expect(messages.count).to be > 0
  end

  it 'should get the RBD IT account (AKA: Me)' do
    me = groupme.get_me
    expect(me['id']).to eq('12486363')
  end

  it 'should be able to send a text message' do
    message = groupme.send_message('8936279', 'GroupMe API "send_message" test')
    expect(message).not_to be_nil
  end

  it 'should add a bot' do
    response = groupme.add_bot(SecureRandom.uuid, '8936279')
    expect(response.length).to be > 0
    groupme.destroy_bot response
  end
end
