require 'rails_helper'
require 'timesheet_to_shift_translator'
require 'shift_writer'

describe LegacyBlueforceTimesheetImporting do
  let(:duration) { 5.minutes }
  let!(:person) { create :person, connect_user_id: connect_user.id }
  let(:connect_user) { build_stubbed :connect_user }
  let(:connect_blueforce_timesheet) {
    build :connect_blueforce_timesheet,
           ad_user_id: connect_user.id,
           updated: Time.now - duration + 1.minute
  }
  let!(:shift_outside_date_range) {
    create :shift, date: connect_blueforce_timesheet.shift_date - 1.day
  }
  let(:translator) {
    ConnectBlueforceTimesheet.
        new.
        extend(TimesheetToShiftTranslator)
  }
  let(:writer) {
    ConnectBlueforceTimesheet.
        new.
        extend(ShiftWriter)
  }

  describe 'initialization' do
    it 'initializes with number of minutes' do
      expect {
        LegacyBlueforceTimesheetImporting.new duration
      }.not_to raise_error
    end

    it 'throws an error when initialized without arguments' do
      expect {
        LegacyBlueforceTimesheetImporting.new
      }.to raise_error(ArgumentError, %r{0 for 1})
    end
  end

  context 'when translating timesheet batch' do
    it 'returns a valid shift' do
      shift = translator.translate connect_blueforce_timesheet
      expect(shift).to be_valid
    end
  end

  context 'when writing shifts to database' do
    it 'increases the shift count' do
      expect {
        writer.write(translator.translate(connect_blueforce_timesheet))
      }.to change(Shift, :count).by(1)
    end

    it 'clears out only shifts within the duration' do
      shift = translator.translate(connect_blueforce_timesheet)
      writer.write shift
      expect(Shift.count).to eq(2)
      expect {
        writer.clear_and_write_all([shift])
      }.to change(Shift, :count).by(-1)
    end
  end

end