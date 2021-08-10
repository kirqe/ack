# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
# 

app_dir = File.expand_path("../..", __FILE__)
set :output, "#{app_dir}/log/crontab.log"
env :PATH, ENV['PATH']

every 1.day, at: '3:00 am' do
  rake "records:lock_old_posts"
end

every 3.days do
  rake "records:purge_unattached"
end

every 1.month, at: '4:00 am' do
  rake "records:delete_old_records"
end

every 1.day, :at => '4:30 am' do
  rake "-s sitemap:refresh"
end

# Learn more: http://github.com/javan/whenever
