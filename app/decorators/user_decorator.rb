# frozen_string_literal: true

module UserDecorator
  def gravatar
    src = "https://gravatar.com/avatar/#{Digest::MD5.hexdigest(id.to_s)}?d=identicon&r=PG&s=200"
    image_tag src, class: 'gravatar'
  end
end
