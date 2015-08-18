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
end
