class LockWorker
  include Sidekiq::Worker

  def perform(*args)    
    Post.where("updated_at < ?",  7.days.ago).each(&:lock!)
  end
end
