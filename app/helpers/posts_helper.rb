module PostsHelper

  def gravatar_url(str)
    "http://gravatar.com/avatar/#{Digest::MD5.hexdigest("#{str}")}?d=identicon&r=PG&s=100"
  end
end