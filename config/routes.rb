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
    resources :projects, only: [:show] do
      resources :area_types, only: [:index]
      resources :areas, only: [:index, :show] do
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
    resources :positions, only: [:index]
  end

  resources :devices do
    member do
      get 'write_off'
      patch 'remove_state/:device_state_id',
            action: :remove_state,
            as: 'remove_state'
      patch 'add_state',
            action: :add_state,
            as: 'add_state'
    end
    resources :device_deployments, except: [ :index ] do
      collection do
        get 'select_user'
        get 'new/:person_id', to: 'device_deployments#new', as: 'new'
        post 'new/:person_id', to: 'device_deployments#create'
        get  'recoup', to: 'device_deployments#recoup'
      end

      member do
        get 'end'
      end

    end
  end

  resources :device_states, except: [:show]

  match '/feedback', to: 'feedbacks#new', via: 'get'
  resources :feedbacks, only: [:new, :create]

  # get 'gallery/index'

  resources :group_mes, only: [] do
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

  resources :lines, only: [:index, :show, :new, :create] do
    collection do
      get 'swap', to: 'lines#swap'
    end

    member do
      patch 'remove_state/:line_state_id',
            action: :remove_state,
            as: 'remove_state'
      patch 'add_state',
            action: :add_state,
            as: 'add_state'
    end
  end

  resources :line_states, except: [:show]

  resources :link_posts, only: [:create, :show]

  resources :log_entries, only: [:index]

  resources :media, only: [:index]

  resources :people, only: [:index, :show, :update] do
    member do
      get 'about', to: 'people#about', as: :about
      get :sales, as: :sales
    end
    collection do
      match 'search' => 'people#search', via: [:get, :post], as: :search
      get :org_chart, as: :org_chart
    end
  end

  # resources :permissions
  # resources :permission_groups

  resources :poll_questions do
    resources :poll_question_choices, only: [:create, :update, :destroy] do
      member do
        get :choose, as: :choose
      end
    end
  end

  resources :profiles, only: [:edit, :update] do
    resources :profile_experiences, except: [:index, :show]
    resources :profile_educations, except: [:index, :show]
    # resources :profile_skills, except: :index
  end

  # resources :questions

  # resources :reports do
  #   member do
  #     get :share, to: 'reports#share', as: 'share'
  #     post :share, to: 'reports#distribute'
  #   end
  # end

  get 'sessions/destroy', as: 'logout'

  resources :text_posts, only: [:create, :show]
  resources :themes, except: [:destroy, :show]

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
      get 'people/onboard/:connect_user_id', to: 'people#onboard', as: 'api_onboard'
      get 'people/separate/:connect_user_id', to: 'people#separate', as: 'api_separate'
      get 'people/update/:connect_user_id', to: 'people#update', as: 'api_update'
    end
  end

end
