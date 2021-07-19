# frozen_string_literal: true

module CommentDecorator
  def byline
    user.gravatar + 
    "by #{user.name} #{time_ago_in_words(created_at)} ago"    
  end

  def sanitaized
    text = body.gsub(/(?:\n\r?|\r\n?)/, '<br>')
    sanitize  text, tags: %w(strong em a), attributes: %w(href)
  end
end
