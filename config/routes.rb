Rails.application.routes.draw do  
  get 'boards/new', to: "boards#new", as: :new_board

  resources :boards, path: '' do
    resources :posts, path: ''
  end


  root to: "boards#index"
end