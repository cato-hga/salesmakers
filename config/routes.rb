Rails.application.routes.draw do

  resources :text_posts, only: [:create, :show, :destroy]
  resources :uploaded_videos, only: [:create, :show]
  resources :uploaded_images, only: [:create, :show]
  resources :wall_posts, only: :destroy do
    member do
      get 'promote/:wall_id', to: 'wall_posts#promote', as: 'promote'
    end
  end

  resources :wall_post_comments, only: [:create, :update, :destroy]

  get 'like/:wall_post_id', to: 'likes#create', as: 'create_like'
  get 'unlike/:wall_post_id', to: 'likes#destroy', as: 'destroy_like'

  resources :group_mes do
    get 'auth', on: :collection, as: 'auth'
    get 'called_back', on: :collection
    get 'groups', on: :collection
    get 'groups_aside', on: :collection
    get 'group_chat_aside/:group_id', to: 'group_mes#group_chat_aside', on: :collection
    post 'post_message', on: :collection
  end

  #get 'group_me/auth', as: 'group_me_auth'

  resources :questions

  resources :media

  resources :blog_posts do
    member do
      get 'publish'
      get 'approve'
      get 'deny'
    end
  end
  get 'blog', to: 'blog_posts#index', as: :blog

  get 'gallery/index'

  root 'home#index'
  resources :home, only: [ :index ]
    get 'home/dashboard'

  resources :people do
    member do
      get 'about', to: 'people#about', as: :about
    end
    collection do
      match 'search' => 'people#search', via: [:get, :post], as: :search
    end
  end
  resources :profiles, only: [:edit, :update] do
    resources :profile_experiences, except: :index
    resources :profile_educations, except: :index
    resources :profile_skills, except: :index
  end


  resources :log_entries, only: [ :index ]

  resources :clients do
    resources :projects, except: :index do
      resources :area_types
      resources :areas
      resources :channels
    end
  end

  resources :reports do
    member do
      get :share, to: 'reports#share', as: 'share'
      post :share, to: 'reports#distribute'
    end
  end

  resources :departments do
    resources :positions
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'people/onboard/:connect_user_id', to: 'people#onboard'
      get 'people/separate/:connect_user_id', to: 'people#separate'
    end
  end

  resources :permissions
  resources :permission_groups

  get 'sessions/destroy', as: 'logout'

  post 'group_me_bot/message', to: 'group_mes#incoming_bot_message'
end
