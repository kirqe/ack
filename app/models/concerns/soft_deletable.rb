# frozen_string_literal: true

module SoftDeletable
  extend ActiveSupport::Concern

  included do
    scope :soft_deleted, -> { where.not(deleted_at: nil) }
    scope :deleted_first, -> { order('deleted_at ASC') }
  end

  def soft_delete!
    update!(deleted_at: DateTime.now)
  end

  def restore!
    update!(deleted_at: nil)
  end

  def soft_deleted?
    !deleted_at.nil?
  end
end
