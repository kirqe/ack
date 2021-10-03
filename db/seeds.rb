# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(username: 'admin', email: 'admin@admin.com', password: 'password')
user.add_role(:admin)

Board.create(name: 'Random', slug: 'rand', body: 'Posts with no category', approved_at: Time.now)
Board.create(name: 'News', slug: 'news', body: 'Anything related to news', approved_at: Time.now)
Board.create(name: 'Music', slug: 'music', body: 'Music related forum', approved_at: Time.now)
Board.create(name: 'TV Shows and Films', slug: 'tv', body: 'TV Shows and Films', approved_at: Time.now)
Board.create(name: 'Games', slug: 'games', body: 'PC/Console games, news, talk', approved_at: Time.now)
Board.create(name: 'Help, Feedback, Suggestions', slug: 'hfs',
             body: 'Questions, feedback, suggestions regarding this forum', approved_at: Time.now)
