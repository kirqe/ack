# frozen_string_literal: true

module Approvable
  extend ActiveSupport::Concern

  included do
    scope :approved, lambda {
      where(rejected_at: nil)
        .and(where.not(approved_at: nil))
        .and(where(deleted_at: nil))
    }
    scope :rejected, -> { where(approved_at: nil).and(where.not(rejected_at: nil)) }
    scope :pending, -> { where(approved_at: nil, rejected_at: nil) }
  end

  def approve!
    update!(approved_at: DateTime.now, rejected_at: nil)
  end

  def reject!
    update!(approved_at: nil, rejected_at: DateTime.now)
  end

  def reset!
    update!(approved_at: nil, rejected_at: nil)
  end

  def approved?
    !approved_at.nil?
  end

  def rejected?
    !rejected_at.nil?
  end

  def pending?
    rejected_at.nil? && approved_at.nil?
  end
end
