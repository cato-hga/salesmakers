# == Schema Information
#
# Table name: sprint_radio_shack_training_sessions
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  start_date :date             not null
#

require 'rails_helper'

describe SprintRadioShackTrainingSession do
  subject { build :sprint_radio_shack_training_session }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end
end
