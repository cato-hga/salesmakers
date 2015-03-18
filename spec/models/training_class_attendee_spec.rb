require 'rails_helper'

RSpec.describe TrainingClassAttendee, :type => :model do

  describe 'validations' do
    let(:attendee) { build :training_class_attendee }
    it 'requires a person' do
      attendee.person_id = nil
      expect(attendee).not_to be_valid
    end
    it 'requires a training class' do
      attendee.training_class_id = nil
      expect(attendee).not_to be_valid
    end
    it 'requires an attended y/n' do
      attendee.attended = nil
      expect(attendee).not_to be_valid
    end
    it 'require a status' do
      attendee.status = nil
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