class TimesheetImporter
  def initialize(duration)
    @duration = duration
    @count = 0
  end

  def import
    timesheets = timesheets_for_last(@duration).order(:shift_date)
    self.extend TimesheetToShiftTranslator
    shifts = self.translate_all(timesheets)
    self.extend ShiftWriter
    self.clear_and_write_all shifts
    self.send_unmatched
    ProcessLog.create process_class: "TimesheetImporter", records_processed: shifts.count
  end

  def send_unmatched
    unmatched = self.unmatched_timesheets || return
    UnmatchedShiftsMailer.unmatched_shifts(unmatched).deliver_later
  end
end