# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def error_tag(post, field, tag = nil)
    errors = post.errors[field]
    return unless errors.any?

    content_tag(:span, "#{(tag || field).capitalize} #{errors.first}", class: 'text-sm text-primary font-bold')
  end

  def error_block(post, field, tag = nil, &block)
    errors = post.errors[field]
    content = capture(&block)
    return content unless errors.any?

    content_tag :div do
      concat(content_tag(:div, class: 'rounded-md border-2 border-primary') do
        content
      end)
      concat(content_tag(:span, "#{(tag || field).capitalize} #{errors.first}",
                         class: 'text-sm text-primary font-bold'))
    end
  end

  def sanitized(text)
    Sanitize.fragment(text, Sanitize::Config.merge(Sanitize::Config::RELAXED,
                                                   elements: %w[div span u i em strong b p br h1 h2 ul ol li a pre
                                                                style img video],
                                                   attributes: {
                                                     'video' => %w[src controls playsinline width height preload]
                                                   },
                                                   css: {
                                                     properties: %w[width color background-color]
                                                   }))
  end

  def hg?(board)
    case controller_name
    when 'boards'
      params[:board_id] == board.slug
    when 'posts'
      board.slug == @post.board.slug
    end
  end

  def aaack
    if controller_name == 'posts' && action_name == 'show'
      board_posts_path(@post.board.slug)
    else
      request.original_url
    end
  end

  def default_meta_tags
    {
      site: 'AAACK!',
      title: 'ACK!',
      reverse: true,
      separator: '-',
      description: 'A place to ack and ack with other people about the ack.',
      keywords: 'aaack, ack, forum',
      canonical: request.original_url
    }
  end
end
