module PostsHelper
  def post_link(post)
    name = post.name
    post.url.empty? ? 
    (link_to name, board_post_path(post.board.slug, post)) : 
    (link_to name, post.url, target: "_blank")
  end

  def error_tag(post, field, t = nil)
    errors = post.errors[field]  
    return unless errors.any?    
    content_tag(:span, "#{(t || field).capitalize} #{errors.first}", class: "text-sm text-primary font-bold")
  end

  def gravatar_url(str)
    "http://gravatar.com/avatar/#{Digest::MD5.hexdigest("#{str}")}?d=identicon&r=PG&s=100"
  end
end