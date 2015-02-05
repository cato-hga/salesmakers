class TimesheetImporter
  def initialize(duration)
    @duration = duration
  end

  def import
    timesheets = timesheets_for_last(@duration)
    self.extend TimesheetToShiftTranslator
    shifts = self.translate_all(timesheets)
    self.extend ShiftWriter
    self.clear_and_write_all shifts
  end
end