# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://#{ENV['HOST']}"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  Board.find_each do |board|
    add board_posts_path(board.slug), :lastmod => board.updated_at, :changefreq => 'daily'

    board.posts.find_each do |post|
      add post_path(post), :lastmod => post.updated_at, :changefreq => 'daily'
    end
  end
end
