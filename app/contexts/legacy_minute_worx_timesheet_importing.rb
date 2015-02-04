# Actors: ConnectUpdater, timesheet batch, shift translator, shift writer
# Goal: Convert rc_timesheet records from SC1.0 to Shifts

# 1. ConnectUpdater sends duration of last-updated timesheets to search for
# 2. System requests a batch of timesheets
# 3. System sends batch to shift translator for translation
# 4. System sends translated shifts to shift writer for storage

class LegacyMinuteWorxTimesheetImporting

  def initialize(duration)
    @duration = duration
  end

  def import
    timesheets = timesheets_for_last(@duration)
    self.extend ShiftTranslator
    shifts = self.translate_all(timesheets)
    self.extend ShiftWriter
    self.clear_and_write_all shifts
  end

  module ShiftTranslator
    def translate_all(connect_timesheets)
      shifts = Array.new
      connect_timesheets.each do |timesheet|
        shift = translate(timesheet)
        shifts << shift if shift
      end
      shifts.uniq
    end

    def translate(timesheet)
      Shift.new person: get_person(timesheet.ad_user_id),
                location: get_location(timesheet.c_bpartner_location_id),
                date: timesheet.shift_date,
                hours: timesheet.hours + timesheet.overtime,
                break_hours: timesheet.time_docked
    end

    def get_person(ad_user_id)
      Person.find_by connect_user_id: ad_user_id
    end

    def get_location(c_bpartner_location_id)
      c_bpl = ConnectBusinessPartnerLocation.find_by c_bpartner_location_id: c_bpartner_location_id
      return nil unless c_bpl
      Location.return_from_connect_business_partner_location c_bpl
    end
  end

  module ShiftWriter
    def clear_and_write_all(shifts)
      written_shifts = Array.new
      for shift in shifts do
        Shift.where('person_id = ? AND date >= ?', shift.person_id, shift.date).
            destroy_all
        written_shifts << shift if write(shift)
      end
      written_shifts
    end

    def write(shift)
      shift.save
    end
  end

  private

  def timesheets_for_last(duration)
    ConnectTimesheet.updated_within_last duration
  end

end