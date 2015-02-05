# Actors: ConnectUpdater, timesheet batch, shift translator, shift writer
# Goal: Convert rc_timesheet records from SC1.0 to Shifts

# 1. ConnectUpdater sends duration of last-updated timesheets to search for
# 2. System requests a batch of timesheets
# 3. System sends batch to shift translator for translation
# 4. System sends translated shifts to shift writer for storage
require 'timesheet_importer'
require 'timesheet_to_shift_translator'
require 'shift_writer'

class LegacyBlueforceTimesheetImporting < TimesheetImporter

  private

  def timesheets_for_last(duration)
    ConnectBlueforceTimesheet.shifts_within_last duration
  end

end