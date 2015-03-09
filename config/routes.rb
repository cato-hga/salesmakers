require 'sidekiq/web'

Rails.application.routes.draw do

  root 'root_redirects#incoming_redirect'

  mount_griddler

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == 'it@retaildoneright.com' && password == 'IT@Supp0rt'
  end
  mount Sidekiq::Web, at: '/sidekiq'

  resources :root_redirects do #DIRTY DIRTY DIRTY
    collection do
      get 'incoming_redirect'
    end
  end

  resources :candidates, except: [:edit, :update, :destroy] do
    resources :prescreen_answers, only: [:new, :create]
    resources :interview_schedules, only: [:new, :create] do
      collection do
        post :time_slots, as: 'time_slots'
        get 'schedule/:interview_date/:interview_time',
            action: :schedule,
            as: :schedule
        get 'interview_now'
      end
    end
    member do
      get :select_location, as: :select_location
      get 'set_location/:location_id', to: :set_location, as: :set_location
      get :send_paperwork, to: :send_paperwork, as: :send_paperwork
      get :new_sms_message, as: :new_sms_message
      post :create_sms_message, as: :create_sms_message
    end
    resources :interview_answers, only: [:new, :create]
    resources :candidate_contacts, only: [:create] do
      collection do
        get 'new_call', to: :new_call, as: :new_call
      end
    end
  end

  resources :changelog_entries, only: [:index, :new, :create]

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

  resources :comcast_customers, except: [:edit, :update, :destroy] do
    resources :comcast_sales, only: [:new, :create]
    resources :comcast_leads, only: [:new, :create, :edit, :update, :destroy]
  end

  resources :comcast_eods, only: [:new, :create]
  resources :comcast_leads, only: [:index] do
    collection do
      get :csv, to: 'comcast_leads#csv', as: :csv, defaults: { format: :csv }
    end
  end
  resources :comcast_sales, only: [:index] do
    collection do
      get :csv, to: 'comcast_sales#csv', as: :csv, defaults: { format: :csv }
    end
  end

  post 'comcast_group_me_bots/message', to: 'comcast_group_me_bots#message'

  resources :departments, only: [:index, :show] do
    resources :positions, only: [:index]
  end

  resources :devices do
    member do
      get 'write_off'
      get 'line_swap_or_move'
      get 'line_swap_results/:device_id',
          action: :line_swap_results,
          as: 'line_swap_results'
      get 'line_move_results/:device_id',
          action: :line_move_results,
          as: 'line_move_results'
      patch 'line_swap_finalize/:device_id',
            action: :line_swap_finalize,
            as: 'line_swap_finalize'
      patch 'line_move_finalize/:device_id',
            action: :line_move_finalize,
            as: 'line_move_finalize'
      patch 'remove_state/:device_state_id',
            action: :remove_state,
            as: 'remove_state'
      patch 'add_state',
            action: :add_state,
            as: 'add_state'
      patch 'lost_stolen',
            action: :lost_stolen,
            as: 'lost_stolen'
      patch 'found',
            action: :found,
            as: 'found'
      patch 'repairing',
            action: :repairing,
            as: 'repairing'
      patch 'repaired',
            action: :repaired,
            as: 'repaired'
    end
    collection do
      get :csv, to: 'devices#csv', as: :csv, defaults: { format: :csv }
    end
    resources :device_deployments, except: [ :index ] do
      collection do
        get 'select_user'
        get 'new/:person_id', to: 'device_deployments#new', as: 'new'
        post 'new/:person_id', to: 'device_deployments#create'
        get  'recoup_notes', to: 'device_deployments#recoup_notes', as: 'recoup_notes'
        post 'recoup', to: 'device_deployments#recoup', as: 'recoup'
      end

      member do
        get 'end'
      end

    end
  end

  resources :device_manufacturers, only: [:new, :create]
  resources :device_models, only: [:index, :new, :create, :edit, :update]
  resources :device_states, except: [:show]

  post 'group_me_bot/message', to: 'group_mes#incoming_bot_message'
  get 'group_me_groups/new_post', to: 'group_me_groups#new_post', as: :new_post_group_me_groups
  post 'group_me_groups/post', to: 'group_me_groups#post', as: :post_group_me_groups

  resources :lines, only: [:index, :show, :new, :create, :update] do
    member do
      patch 'remove_state/:line_state_id',
            action: :remove_state,
            as: 'remove_state'
      patch 'add_state',
            action: :add_state,
            as: 'add_state'
      patch 'deactivate',
            action: :deactivate,
            as: 'deactivate'
    end
  end

  resources :line_states, except: [:show]

  resources :log_entries, only: [:index]

  resources :people, only: [:index, :show, :update] do
    member do
      get :commission, as: :commission
      post :commission
      get :sales, as: :sales
      get :new_sms_message, as: :new_sms_message
      post :create_sms_message, as: :create_sms_message
      put 'update_changelog_entry_id/:changelog_entry_id',
          to: 'people#update_changelog_entry_id',
          as: :update_changelog_entry_id
    end
    collection do
      match 'search' => 'people#search', via: [:get, :post], as: :search
      get :org_chart, as: :org_chart
      get :csv, to: 'people#csv', as: :csv, defaults: { format: :csv }
    end
  end

  get 'sessions/destroy', as: 'logout'

  post 'sprint_group_me_bots/message', to: 'sprint_group_me_bots#message'

  post 'twilio/incoming_voice', as: 'incoming_voice_twilio'
  post 'twilio/incoming_sms', as: 'incoming_sms_twilio'


  # ------------------------- API NAMESPACE --------------------------

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'people/onboard/:connect_user_id', to: 'people#onboard', as: 'api_onboard'
      get 'people/separate/:connect_user_id', to: 'people#separate', as: 'api_separate'
      get 'people/update/:connect_user_id', to: 'people#update', as: 'api_update'
    end
  end

end

# OLD CRAP
# resources :blog_posts, only: [:index, :show] do
#   member do
#     get 'publish'
#     get 'approve'
#     get 'deny'
#   end
# end

# get 'gallery/index'

# resources :home, only: [:index]

# get 'home/dashboard'
#  match '/feedback', to: 'feedbacks#new', via: 'get'
# resources :feedbacks, only: [:new, :create
# get 'like/:wall_post_id', to: 'likes#create', as: 'create_like'
# get 'unlike/:wall_post_id', to: 'likes#destroy', as: 'destroy_like'

# resources :link_posts, only: [:create, :show]

# resources :media, only: [:index]

# resources :permissions
# resources :permission_groups

# resources :poll_questions do
#   resources :poll_question_choices, only: [:create, :update, :destroy] do
#     member do
#       get :choose, as: :choose
#     end
#   end
# end

# resources :profiles, only: [:edit, :update] do
#   resources :profile_experiences, except: [:index, :show]
#   resources :profile_educations, except: [:index, :show]
#   resources :profile_skills, except: :index
# end

# resources :questions

# resources :reports do
#   member do
#     get :share, to: 'reports#share', as: 'share'
#     post :share, to: 'reports#distribute'
#   end
# end

# resources :text_posts, only: [:create, :show]
# resources :themes, except: [:destroy, :show]
# resources :uploaded_videos, only: [:create, :show]
# resources :uploaded_images, only: [:create, :show]
#
# resources :wall_posts, only: [:show, :destroy] do
#   member do
#     get 'promote/:wall_id', to: 'wall_posts#promote', as: 'promote'
#   end
# end
# resources :wall_post_comments, only: [:create, :update, :destroy]
