# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :path, '/opt/oneconnect/current'

every 5.minutes do
  runner 'EmailBouncebackNotifierJob.perform_later(5, true)'
  runner 'LegacyVonageSaleImporting.new(5.minutes).import(true)'
  runner 'LegacySprintSaleImporting.new.execute'
end

every 15.minutes do
  runner 'DaySalesCount.import(true)'
  runner 'SalesPerformanceRank.rank_people_sales(true)'
  runner 'SalesPerformanceRank.rank_areas_sales(true)'
end

every 30.minutes do
  runner 'ConnectUpdater.update(30, true)'
  runner 'VonageCommissionProcessing.new.process(true)'
  runner 'WorkmarketImport.new.execute(true)'
end

every :hour do
  runner 'GroupMeGroup.update_groups(true)'
  runner 'TimesheetSynchronization.new(Date.today - 22.days - 1.month, Date.today - 22.days).process'
end

every 3.hours do
  runner 'ConnectUpdater.update_shifts(3.weeks, true)'
end

every 1.day, at: '12:00 pm' do
  runner 'DailyProcessLogMailer.generate.deliver_later'
  runner 'NotificationMailer.vonage_hours_with_no_location.deliver_later'
end

every 1.day, at: '5:00 pm' do
  runner 'GroupMeGroup.notify_of_assets(240, true)'
end

every 1.day, at: '2:00 am' do
  runner 'GroupMeGroup.notify_of_assets(240, true)'
end

every 1.day, at: '4:00 am' do
  runner 'AssetShiftHoursTotaling.new(24.hours, true)'
end

every 1.day, at: '11:30 pm' do
  runner 'HistoricalRecording.new.record'
end

every :wednesday, at: '9:00 am' do
  runner 'AssetShiftHoursTotaling.generate_mailer(true)'
end
