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

every :hour do
  runner 'GroupMeGroup.update_groups'
end

every 15.minutes do
  runner 'DaySalesCount.import'
end

every 15.minutes do
  runner 'SalesPerformanceRank.rank_people_sales'
end

every 15.minutes do
  runner 'SalesPerformanceRank.rank_areas_sales'
end

every 30.minutes do
  runner 'ConnectUpdater.update(30)'
end

every 3.hours do
  runner 'ConnectUpdater.update_shifts(1.week)'
end

every 1.day, at: '8:00 am' do
  runner 'ConnectUpdater.update_shifts(17.days)'
end

every 5.minutes do
  runner 'LegacyVonageSaleImporting.new(5.minutes).import'
end

every 1.day, at: '5:00 pm' do
  runner 'GroupMeGroup.notify_of_assets(240)'
end

every 1.day, at: '2:00 am' do
  runner 'GroupMeGroup.notify_of_assets(240)'
end
