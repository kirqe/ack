# frozen_string_literal: true

module CommentDecorator
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

  def sanitaized
    text = body.gsub(/(?:\n\r?|\r\n?)/, '<br>')
    sanitize text, tags: %w(strong b i em a br), attributes: %w(href)
  end
end
