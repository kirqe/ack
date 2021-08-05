module Publishable
  extend ActiveSupport::Concern

  included do
    scope :published, -> { where.not(published_at: nil) }
    scope :hidden, -> { where(published_at: nil) }
  end

  def publish!
    update!(published_at: DateTime.now)
  end

  def unpublish!
    update!(published_at: nil)
  end

  def published?
    !published_at.nil?
  end

  def hidden?
    published_at.nil?
  end
end