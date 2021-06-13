# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

boards = []
boards << Board.create(name: "one", slug: "one", body: "description")
boards << Board.create(name: "two", slug: "two", body: "description")
Board.create(name: "three", slug: "three", body: "description")

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