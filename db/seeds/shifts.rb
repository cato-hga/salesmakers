puts "Importing 90+ days of MinuteWorx shifts. Please be patient. You will " +
         "not be given a count and this will take quite some time..."

context = LegacyMinuteWorxTimesheetImporting.new 90.days
shifts = context.import
puts "#{shifts.count.to_s} shifts imported."
puts "#{context.unmatched_timesheets.count.to_s} shifts were not able to be " +
         "matched to a person."

puts "Importing 90 days of Blueforce shifts. Please be patient. You will " +
         "not be given a count and this will take quite some time..."

context = LegacyBlueforceTimesheetImporting.new 90.days
shifts = context.import
puts "#{shifts.count.to_s} shifts imported."
puts "#{context.unmatched_timesheets.count.to_s} shifts were not able to be " +
         "matched to a person."