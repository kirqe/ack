Rails.application.routes.draw do     
  root to: "boards#index"
  devise_for :users, path: 'auth', 
  path_names: { sign_in: 'signin', sign_out: 'signout', sign_up: 'signup'},
  controllers: { registrations: "users/registrations" }

  match 'u/:username' => 'users#show', via: :get, as: :user
  
  get 'boards/new', to: "boards#new", as: :new_board  

  resources :boards, path: '' do
    resources :posts, path: '', except: :show do
      get 'search', to: "posts#index", on: :collection
    end
  end

  resources :posts, path: 'p', only: [:show] do
    resources :comments, module: 'posts'
    resources :votes, only: [:create], module: 'posts'

    # @votable cant be set for some reason
    # member do
    #   post "vote", to: "votes#create"  
    # end
  end
  
  get "f/:filter", to: "boards#index", as: :filtered_boards
  get ":board_id/:filter", to: "posts#index", as: :filtered_board_posts

  resources :comments do
    resources :comments
  end

  scope module: 'admin' do
    resources :boards, only: [] do
      member do
        patch 'approve'
        patch 'reject'
        patch 'delete'
        patch 'reset'
      end      
    end

    resources :posts, only: [] do
      member do
        patch 'pin'
        patch 'lock'
        patch 'publish'
        patch 'delete'
      end
    end

    resources :comments, only: [] do
      member do
        patch 'delete'
      end
    end

    resources :users, only: [] do
      member do
        patch 'suspend'
      end
    end
  end

  get '*all', to: 'application#index', constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  }
end