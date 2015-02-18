require 'rails_helper'

describe SprintGroupMeBot do
  subject { build :sprint_group_me_bot }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a group_num' do
    subject.group_num = nil
    expect(subject).not_to be_valid
  end

  it 'requires a bot_num' do
    subject.bot_num = nil
    expect(subject).not_to be_valid
  end

  it 'requires an area_id' do
    subject.area_id = nil
    expect(subject).not_to be_valid
  end

  it 'does not allow duplicate bot_num' do
    subject.save
    new_bot = build :sprint_group_me_bot, group_num: '88776655'
    expect(new_bot).not_to be_valid
  end
end