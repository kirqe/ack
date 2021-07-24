Rails.application.routes.draw do  
  # devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirma tion: 'verification', unlock: 'unblock', registration: 'register' }
  devise_for :users, path: 'auth', path_names: { sign_in: 'signin', sign_out: 'signout', sign_up: 'signup'}

  get 'boards/new', to: "boards#new", as: :new_board

  post ":post_id/vote", to: "posts/votes#vote", as: :vote_post



  post "posts/:post_id/comments", to: "posts/comments#create", as: :post_comments
  get "posts/:post_id/comments", to: "posts/comments#index", as: :post_commens
  
  get "posts/:post_id/comments/:comment_id/replies", to: "comments#replies", as: :comment_replies


  resources :boards, path: '' do
    resources :posts, path: ''
  end


  resources :posts do
    resources :comments
  end
  
  resources :comments do
    resources :comments
  end

  root to: "boards#index"
end