module Suspendable
  extend ActiveSupport::Concern

  included do
    scope :suspended, -> { where.not(suspended_till: nil) }
  end

  def suspend!(n=1)
    update!(suspended_till: DateTime.now + n.days)
  end

  def resume!
    update!(suspended_till: nil)
  end

  def suspended?
    !(suspended_till.nil? || auto_resumed?)
  end

  def auto_resumed?
    suspended_till && (DateTime.now > suspended_till)
  end
end