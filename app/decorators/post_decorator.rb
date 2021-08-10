# frozen_string_literal: true

module PostDecorator
  def title
    url.empty? ? 
    (link_to name, post_path(self)) : 
    (link_to name, url, target: "_blank")
  end

  def link(args = {})
    external_link = args[:host] ? URI.parse(url).host : url
  end

  def rich_text
    sanitized(body).html_safe unless body.empty?
  end

  def byline 
    user.gravatar + 
    "by #{user.username} #{time_ago_in_words(created_at)} ago"    
  end

  def byline_linked
    content_tag :span, class: "flex space-x-1" do
      concat(user.gravatar)
      concat(content_tag(:span, "by"))      
      concat(link_to("#{user.username}", user_path(user.username), class: "underline"))      
      concat(content_tag(:span, time_ago_in_words(created_at)))
      concat(content_tag(:span, "ago"))
    end
  end  
end
