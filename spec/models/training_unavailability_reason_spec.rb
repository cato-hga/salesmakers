# == Schema Information
#
# Table name: training_unavailability_reasons
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe TrainingUnavailabilityReason do
  subject { build :training_unavailability_reason }

  it 'requires a name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  it 'responds has_many training_availabilities' do
    expect(subject).to respond_to(:training_availabilities)
  end
end
