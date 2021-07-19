# frozen_string_literal: true

module UserDecorator
  def gravatar
    src = "http://gravatar.com/avatar/#{Digest::MD5.hexdigest("#{id}")}?d=identicon&r=PG&s=100"  
    image_tag src, class: "rounded-full mr-1 w-5 h-5"    
  end
end
