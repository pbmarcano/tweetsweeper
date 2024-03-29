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

# every 1.day do
#   rake "tweets:fetch"
#   rake "heya:scheduler"
# end

every 12.hours do
  # rake "tweets:sweep"
end

every 1.day, at: '2:30 am' do
  rake "trials:delete_users"
end

every :sunday, at: '05:00pm' do
  # rake "upcoming:notify_users"
end
