# == Schema Information
#
# Table name: communication_log_entries
#
#  id            :integer          not null, primary key
#  loggable_id   :integer          not null
#  loggable_type :string           not null
#  created_at    :datetime
#  updated_at    :datetime
#  person_id     :integer          not null
#

require 'rails_helper'

describe CommunicationLogEntry do
  subject { build :communication_log_entry }

  it 'saves when all required fields are present' do
    expect(subject).to be_valid
  end

  it 'requires a loggable' do
    subject.loggable = nil
    expect(subject).not_to be_valid
  end

  it 'requires a person' do
    subject.person = nil
    expect(subject).not_to be_valid
  end

end
