# frozen_string_literal: true

module Pinnable
  extend ActiveSupport::Concern

  included do
    scope :pinned, -> { where.not(pinned_at: nil) }
    scope :pinned_first, -> { order('pinned_at ASC') }
  end

  def pin!
    update!(pinned_at: DateTime.now)
  end

  def pinned?
    !pinned_at.nil?
  end

  def unpin!
    update!(pinned_at: nil)
  end
end
