# frozen_string_literal: true

Rails.configuration.to_prepare do
  ActiveStorage::Blob.class_eval do
    # validates :content_type, content_type: { in: ALLOWED_CONTENT_TYPES, message: 'is not valid' }
    validates :byte_size, numericality: { less_than: 100_000_000, message: 'is too big' } # 100mb
  end
end
