# frozen_string_literal: true

json.extract! post, :id, :name, :body, :created_at
json.url post_url(post)
