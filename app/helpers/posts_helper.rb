module PostsHelper
  def post_link(post)
    name = post.name
    post.url.empty? ? 
    (link_to name, post) : 
    (link_to name, post.url, target: "_blank")
  end

  def error_tag(post, field, t = nil)
    errors = post.errors[field]  
    return unless errors.any?
    content_tag(:span, "#{t || field} #{errors.first}", class: "text-sm text-red-400 font-bold")
  end
end