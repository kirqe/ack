# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

boards = []
boards << Board.create(name: "Random", slug: "rand", body: "Posts with no category")
boards << Board.create(name: "News", slug: "news", body: "Anything related to news")
boards << Board.create(name: "Music", slug: "music", body: "Music related forum")
boards << Board.create(name: "TV Shows and Films", slug: "tv", body: "TV Shows and Films")
boards << Board.create(name: "Games", slug: "games", body: "PC/Console games, news, talk")
boards << Board.create(name: "Help, Feedback, Suggestions", slug: "hfs", body: "Questions, feedback, suggestions regarding this forum")


users = []
100.times do 
  users << User.create(ip: Faker::Internet.ip_v4_address)
end

posts = []
70.times do |i|
  posts << Post.create(
    user: users.sample,
    name: "#{i} ---", 
    url: "http://localhost", 
    body: Faker::Lorem.paragraph(sentence_count: rand(3..7)),
    board: boards.sample)
end

100.times do |i|
  post = posts.sample
  user = users.sample
  loop do
    post = posts.sample      
    break if !user.voted_for?(post)
  end
  Vote.create(user: user, votable: post)
end