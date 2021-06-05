# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


users = []
10.times do 
  users << User.create(ip: Faker::Internet.ip_v4_address)
end

50.times do
  Post.create(
    user: users.sample,
    name: Faker::Lorem.sentence(word_count: rand(4..10)), 
    url: "http://localhost", 
    body: Faker::Lorem.paragraph(sentence_count: rand(3..7)))
end
