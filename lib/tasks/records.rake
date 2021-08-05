namespace :records do
  desc "delete records where deleted_at > 30 days"
  task delete_old_records: :environment do
    Post.where("deleted_at < ?", 30.days.ago).destroy_all
  end
end