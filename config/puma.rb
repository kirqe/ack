max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

app_dir = File.expand_path("../..", __FILE__)
directory app_dir
shared_dir = "#{app_dir}/tmp"

if ENV.fetch("RAILS_ENV", "production")
  stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true
end

worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

port ENV.fetch("PORT") { 3000 }

environment ENV.fetch("RAILS_ENV") { "development" }

# Specifies the `pidfile` that Puma will use.
# pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

workers ENV.fetch("WEB_CONCURRENCY") { 2 }
preload_app!

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end