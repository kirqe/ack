namespace :records do
  desc "delete records where deleted_at > 30 days"
  task delete_old_records: :environment do
    Post.where("deleted_at < ?", 30.days.ago).destroy_all
  end

  desc "lock posts with no activity"
  task lock_old_posts: :environment do
    Post.where("updated_at < ?", Post::LOCK_AFTER.ago).each(&:lock!)
  end

  desc "Purges unattached Active Storage blobs. Run regularly."
  task purge_unattached: :environment do
    ActiveStorage::Blob.unattached.where("active_storage_blobs.created_at <= ?", 2.days.ago).find_each(&:purge_later)
  end
end



