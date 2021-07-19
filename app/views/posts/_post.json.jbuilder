json.extract! post, :id, :name, :body, :created_at
json.url board_post_url(post.board.slug, post)
