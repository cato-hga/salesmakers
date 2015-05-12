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
    self.send_unmatched
  end

  def send_unmatched
    unmatched = self.unmatched_shifts || return
    UnmatchedVonageSalesMailer.unmatched_shifts(unmatched).deliver_later
  end
end