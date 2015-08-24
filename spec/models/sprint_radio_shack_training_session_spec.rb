# == Schema Information
#
# Table name: sprint_radio_shack_training_sessions
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  start_date :date             not null
#  locked     :boolean          default(FALSE), not null
#

require 'rails_helper'

describe SprintRadioShackTrainingSession do
  subject { build :sprint_radio_shack_training_session }

  it 'responds to locked?' do
    expect(subject).to respond_to(:locked?)
  end
end
