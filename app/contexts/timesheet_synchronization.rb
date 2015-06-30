require 'timesheet_to_shift_translator'

class TimesheetSynchronization
  extend TimesheetToShiftTranslator

  def initialize start_date, end_date
    @start_date, @end_date = start_date, end_date
  end

  def process
    @shifts = Shift.totals_by_person_for_date_range @start_date, @end_date
    timesheet_count = 0
    timesheet_count += process_timesheets ConnectBlueforceTimesheet
    timesheet_count += process_timesheets ConnectTimesheet
    timesheet_count
  end

  private

  def process_timesheets klass
    timesheets = klass.totals_by_person_for_date_range @start_date, @end_date
    unmatched_people = get_unmatched timesheets
    import_unmatched klass, unmatched_people
    unmatched_people.count
  end

  def get_unmatched timesheets
    unmatched = []
    for timesheet in timesheets do
      found_hours = @shifts.find { |row| row['connect_user_id'] == timesheet['connect_user_id'] }
      unmatched << timesheet unless found_hours and found_hours['hours'] == timesheet['hours']
    end
    unmatched.find_all { |u| u['connect_user_id'] }
  end

  def import_unmatched klass, unmatched_people
    return if unmatched_people.empty?
    connect_user_ids = unmatched_people.map { |p| p['connect_user_id'] }
    connect_shifts = klass.where "shift_date >= ? AND shift_date <= ? AND ad_user_id IN (?)",
                                 @start_date,
                                 @end_date,
                                 connect_user_ids
    shifts = self.class.translate_all connect_shifts
    destroy_old_shifts connect_user_ids
    write_shifts shifts
    self
  end

  def destroy_old_shifts connect_user_ids
    Shift.joins(:person).where("date >= ? and date <= ? AND people.connect_user_id IN (?)", @start_date, @end_date, connect_user_ids).destroy_all
    self
  end

  def write_shifts shifts
    shifts.each { |shift| shift.save }
    self
  end
end