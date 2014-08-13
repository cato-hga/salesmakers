Rails.application.routes.draw do

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
  resources :people do
    collection do
      match 'search' => 'people#search', via: [:get, :post], as: :search
    end
    resource :profile, only: [:edit, :update]
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
    resources :projects do
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

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
