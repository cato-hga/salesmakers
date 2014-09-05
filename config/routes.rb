Rails.application.routes.draw do

  get 'posts/create'

  resources :group_mes do
    get 'auth', on: :collection
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
    collection do
      match 'search' => 'people#search', via: [:get, :post], as: :search
    end
    resource :profile, only: [:edit, :update, :show]
  end

  resources :lines
  resources :devices do
    resources :device_deployments, except: [ :index, :new, :create ] do
      collection do
        get 'select_user'
        get 'new/:person_id', to: 'device_deployments#new', as: 'new'
        post 'new/:person_id', to: 'device_deployments#create'
      end

      member do
        get 'end'
      end

    end
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

  resources :themes, except: [:show]

  resources :permissions
  resources :permission_groups

  get 'widgets/sales'
  get 'widgets/sales/people/:person_id', to: 'widgets#person_sales', as: 'person_sales_widget'
  get 'widgets/hours'
  get 'widgets/hours/people/:person_id', to: 'widgets#person_hours', as: 'person_hours_widget'
  get 'widgets/tickets'
  get 'widgets/tickets/people/:person_id', to: 'widgets#person_tickets', as: 'person_tickets_widget'
  get 'widgets/social'
  get 'widgets/alerts'
  get 'widgets/alerts/people/:person_id', to: 'widgets#person_alerts', as: 'person_alerts_widget'
  get 'widgets/image_gallery'
  get 'widgets/inventory'
  get 'widgets/inventory/people/:person_id', to: 'widgets#person_inventory', as: 'person_inventory_widget'
  get 'widgets/staffing'
  get 'widgets/gaming'
  get 'widgets/commissions'
  get 'widgets/training'
  get 'widgets/gift_cards'
  get 'widgets/gift_cards/people/:person_id', to: 'widgets#person_gift_cards', as: 'person_gift_cards_widget'
  get 'widgets/pnl'
  get 'widgets/pnl/people/:person_id', to: 'widgets#person_pnl', as: 'person_pnl_widget'
  get 'widgets/hps'
  get 'widgets/hps/people/:person_id', to: 'widgets#person_hps', as: 'person_hps_widget'
  get 'widgets/assets'
  get 'widgets/assets/people/:person_id', to: 'widgets#person_assets', as: 'person_assets_widget'
  get 'widgets/groupme_slider'


  get 'sessions/destroy', as: 'logout'

  post 'group_me_bot/message', to: 'group_mes#incoming_bot_message'
end
