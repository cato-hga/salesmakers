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