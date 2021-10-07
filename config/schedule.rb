# frozen_string_literal: true

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#

app_dir = File.expand_path('..', __dir__)
set :output, "#{app_dir}/log/crontab.log"
set :env_path, '"$HOME/.rbenv/shims":"$HOME/.rbenv/bin"'
job_type :rake,
         ' cd :path && PATH=:env_path:"$PATH" ' \
         ' RAILS_ENV=:environment DISABLE_SPRING=true bin/rake :task --silent :output '
job_type :rails,
         ' cd :path && PATH=:env_path:"$PATH" ' \
         ' RAILS_ENV=:environment DISABLE_SPRING=true bin/rails :task --silent :output '

every 1.day, at: '3:00 am' do
  rails 'records:lock_old_posts'
end

every 3.days do
  rails 'records:purge_unattached'
end

every 1.month, at: '4:00 am' do
  rails 'records:delete_old_records'
end

every 1.day, at: '4:30 am' do
  rails '-s sitemap:refresh'
end

# Learn more: http://github.com/javan/whenever
