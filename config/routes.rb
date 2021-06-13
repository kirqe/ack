Rails.application.routes.draw do  
  get 'boards/new', to: "boards#new", as: :new_board

  post ":post_id/vote", to: "posts/votes#vote", as: :vote_post

  resources :boards, path: '' do
    resources :posts, path: ''
  end


    


 


  root to: "boards#index"
end