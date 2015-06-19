# == Schema Information
#
# Table name: training_availabilities
#
#  id                                :integer          not null, primary key
#  able_to_attend                    :boolean          default(FALSE), not null
#  training_unavailability_reason_id :integer
#  comments                          :text
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  candidate_id                      :integer          not null
#

require 'rails_helper'

describe TrainingAvailability do
  subject { build :training_availability }

  it 'requires an able_to_attend boolean' do
    subject.able_to_attend = nil
    expect(subject).not_to be_valid
  end

  it 'requires a candidate' do
    subject.candidate = nil
    expect(subject).not_to be_valid
  end

  describe 'when not able to attend' do
    before do
      subject.able_to_attend = false
      subject.training_unavailability_reason = create(:training_unavailability_reason)
    end

    it 'requires a training_unavailability_reason' do
      subject.training_unavailability_reason = nil
      expect(subject).not_to be_valid
    end
  end

end
