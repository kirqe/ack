# frozen_string_literal: true

module ExceptionsRedirect
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |_exception|
      flash[:notice] = t('activerecord.exceptions.not_found')
      redirect_to root_url
    end
  end
end
