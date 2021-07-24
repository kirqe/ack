# frozen_string_literal: true

module PostDecorator
  def title
    url.empty? ? 
    (link_to name, board_post_path(board.slug, self)) : 
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
end
