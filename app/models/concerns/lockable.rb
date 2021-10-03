# frozen_string_literal: true

module Lockable
  extend ActiveSupport::Concern

  included do
    scope :locked, -> { where.not(locked_at: nil) }
    scope :locked_first, -> { order('locked_at ASC') }
  end

  def lock!
    update!(locked_at: DateTime.now)
  end

  def unlock!
    update!(locked_at: nil)
  end

  def locked?
    !locked_at.nil?
  end
end
