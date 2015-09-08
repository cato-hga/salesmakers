# == Schema Information
#
# Table name: training_class_attendees
#
#  id                         :integer          not null, primary key
#  person_id                  :integer          not null
#  training_class_id          :integer          not null
#  attended                   :boolean          default(FALSE), not null
#  dropped_off_time           :datetime
#  drop_off_reason_id         :integer
#  status                     :integer          not null
#  conditional_pass_condition :text
#  group_me_setup             :boolean          default(FALSE), not null
#  time_clock_setup           :boolean          default(FALSE), not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

require 'rails_helper'

describe TrainingClassAttendee do

  describe 'validations' do
    let(:attendee) { build :training_class_attendee }

    it 'requires an attended y/n' do
      attendee.attended = nil
      expect(attendee).not_to be_valid
    end

    it 'requires a group me setup y/n' do
      attendee.group_me_setup = nil
      expect(attendee).not_to be_valid
    end

    it 'requires a time clock setup y/n' do
      attendee.time_clock_setup = nil
      expect(attendee).not_to be_valid
    end
  end

end
