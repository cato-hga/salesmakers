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

# 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
# 1 1 1 1 2 1 1 2 1 2 1  2  1  1  2  1
# 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
# 1  1  1  2  1  1  2  1  1     2  1  1  1  1
# 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45
# 1  1  1  2     1  2  1  2  1  2  1  1  1
# 46 47 48 49 50 51 52 53 54 55 56 57 58 59
# 1  1  1  2     1  1  1  1     2  1  1  2

# ------------------------------------ MINUTES OF EVERY HOUR ----------------------------------------

every '1,6,11,16,21,26,31,36,41,46,51,56 * * * *' do
  runner 'EmailBouncebackNotifierJob.perform_later(5, true)'
end

every '2,7,12,17,22,27,32,37,42,47,52,57 * * * *' do
  runner 'LegacyVonageSaleImporting.new(5.minutes).import(true)'
end

every '3,8,13,18,23,28,33,38,43,48,53,58 * * * *' do
  runner 'LegacySprintSaleImporting.new.execute'
end

every '4,9,14,19,24,29,34,39,44,49,54,59' do
  runner 'WalmartGiftCardFTPImporter.new'
end

every '4,19,34,49 * * * *' do
  runner 'DaySalesCount.import(true)'
end

every '7,22,37,52 * * * *' do
  runner 'SalesPerformanceRank.rank_people_sales(true)'
end

every '11,26,41,56 * * * *' do
  runner 'SalesPerformanceRank.rank_areas_sales(true)'
end

every '9,39 * * * *' do
  runner 'ConnectUpdater.update(30, true)'
end

every '10,40 * * * *' do
  runner 'VonageCommissionProcessing.new.process(true)'
end

every '0,30 * * * *' do
  runner 'WorkmarketImport.new.execute(true)'
end

every '5 * * * *' do
  runner 'GroupMeGroup.update_groups(true)'
end

every '59 * * * *' do
  runner 'VonageComp07012015Processing.new.execute'
  runner 'PersonAddress.update_from_connect(270, true)'
end

every '14 0,3,6,9,12,15,18,21 * * *' do
  runner 'ConnectUpdater.update_shifts(2.weeks, true)'
end

every 1.day, at: '11:44 am' do
  runner 'DailyProcessLogMailer.generate.deliver_later'
end

every 1.day, at: '12:15 pm' do
  runner 'NotificationMailer.vonage_hours_with_no_location.deliver_later'
end

every 1.day, at: '3:20 pm' do
  runner 'VonageVestingUpdater.new.update'
end

every 1.day, at: '5:15 pm' do
  runner 'GroupMeGroup.notify_of_assets(240, true)'
end

every 1.day, at: '1:54 am' do
  runner 'GroupMeGroup.notify_of_assets(240, true)'
end

every 1.day, at: '12:54 am' do
  runner 'AssetShiftHoursTotaling.new(24.hours, true)'
end

every 1.day, at: '11:24 pm' do
  runner 'HistoricalRecording.new.record'
end

every :monday, at: '12:54 pm' do
  runner 'RosterVerificationNotificationJob.perform_later(true)'
end

every :wednesday, at: '11:24 am' do
  runner 'AssetShiftHoursTotaling.generate_mailer(true)'
end