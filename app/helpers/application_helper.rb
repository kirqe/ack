module ApplicationHelper
  include Pagy::Frontend

  def error_tag(post, field, t = nil)
    errors = post.errors[field]  
    return unless errors.any?    
    content_tag(:span, "#{(t || field).capitalize} #{errors.first}", class: "text-sm text-primary font-bold")
  end

  def error_block(post, field, t = nil, &block)
    errors = post.errors[field]
    content = capture(&block) 
    return content unless errors.any?    

    content_tag :div do
      concat(content_tag(:div, class: "rounded-md border-2 border-primary") do
        content        
      end)
      concat(content_tag(:span, "#{(t || field).capitalize} #{errors.first}", class: "text-sm text-primary font-bold"))
    end
  end

  def sanitized(text)
    Sanitize.fragment(text, Sanitize::Config.merge(Sanitize::Config::RELAXED,
      elements: %w[div span u i em strong b p br h1 h2 ul ol li a pre style img video],
      attributes: { 
        'video' => %w[src controls playsinline width height preload],  
      },
      css: {
        properties: ['width', 'color', 'background-color']
      }
    ))
  end

  def is_hg?(board) 
    params[:board_id] == board.slug
  end

  def aaack
    controller_name == "posts" && action_name == "show" ?
      board_posts_path(@post.board.slug) :
      request.original_url    
  end
end
