# == Schema Information
#
# Table name: device_states
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#  locked     :boolean          default(FALSE)
#

require 'rails_helper'

describe DeviceState do
  subject { build :device_state }

  it 'requires a unique name' do
    subject.save
    new_device_state = build :device_state
    expect(new_device_state).not_to be_valid
  end
end
