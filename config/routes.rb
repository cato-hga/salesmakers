Rails.application.routes.draw do
  root 'home#index'

  resources :blog_posts, only: [:index, :show] do
    # member do
    #   get 'publish'
    #   get 'approve'
    #   get 'deny'
    # end
  end

  resources :clients, only: [:index, :show] do
    resources :projects, except: :index do
      resources :area_types, only: [:index]
      resources :areas do
        member do
          get :sales, as: :sales
        end
      end
      resources :channels
      member do
        get :sales, as: :sales
      end
    end
    member do
      get :sales, as: :sales
    end
  end

  resources :departments, only: [:index, :show] do
    resources :positions
  end

  match '/feedback', to: 'feedbacks#new', via: 'get'
  resources :feedbacks, only: [:new, :create]

  # get 'gallery/index'

  resources :group_mes do
    get 'auth', on: :collection, as: 'auth'
    get 'called_back', on: :collection
    get 'groups', on: :collection
    get 'groups_aside', on: :collection
    get 'group_chat_aside/:group_id', to: 'group_mes#group_chat_aside', on: :collection
    post 'post_message', on: :collection
  end

  post 'group_me_bot/message', to: 'group_mes#incoming_bot_message'

  resources :home, only: [ :index ]
  # get 'home/dashboard'

  get 'like/:wall_post_id', to: 'likes#create', as: 'create_like'
  get 'unlike/:wall_post_id', to: 'likes#destroy', as: 'destroy_like'

  resources :link_posts, only: [:create, :show]

  resources :log_entries, only: [ :index ]

  resources :media

  resources :people do
    member do
      get 'about', to: 'people#about', as: :about
      get :sales, as: :sales
    end
    collection do
      match 'search' => 'people#search', via: [:get, :post], as: :search
      get :org_chart, as: :org_chart
    end
  end

  resources :permissions
  resources :permission_groups

  resources :poll_questions, only: [:new, :create, :index]

  resources :profiles, only: [:edit, :update] do
    resources :profile_experiences, except: :index
    resources :profile_educations, except: :index
    resources :profile_skills, except: :index
  end

  resources :questions

  resources :reports do
    member do
      get :share, to: 'reports#share', as: 'share'
      post :share, to: 'reports#distribute'
    end
  end

  get 'sessions/destroy', as: 'logout'

  resources :text_posts, only: [:create, :show, :destroy]

  resources :uploaded_videos, only: [:create, :show]
  resources :uploaded_images, only: [:create, :show]

  resources :wall_posts, only: [:show, :destroy] do
    member do
      get 'promote/:wall_id', to: 'wall_posts#promote', as: 'promote'
    end
  end
  resources :wall_post_comments, only: [:create, :update, :destroy]

  # ------------------------- API NAMESPACE --------------------------

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'people/onboard/:connect_user_id', to: 'people#onboard'
      get 'people/separate/:connect_user_id', to: 'people#separate'
      get 'people/update/:connect_user_id', to: 'people#update'
    end
  end

end
