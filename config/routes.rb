require 'sidekiq/web'

Rails.application.routes.draw do

  get 'comcast_customer_notes/create'

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

  get 'asset_approvals/approval', to: 'asset_approvals#approval', as: :asset_approval
  patch 'asset_approvals/approve/:person_id', to: 'asset_approvals#approve', as: :approve_for_asset
  patch 'asset_approvals/deny/:person_id', to: 'asset_approvals#deny', as: :deny_for_asset

  resources :candidates do
    resources :prescreen_answers, only: [:new, :create]
    resources :candidate_availabilities, only: [:new, :create, :edit, :update]
    resources :training_availabilities, only: [:new, :create, :edit, :update]
    resources :sprint_pre_training_welcome_calls, only: [:new, :create, :edit, :update]
    resources :candidate_drug_tests, only: [:new, :create]
    resources :candidate_notes, only: [:create]
    resources :interview_schedules, only: [:new, :create, :destroy] do
      collection do
        post :time_slots, as: 'time_slots'
        post 'schedule/:interview_date/:interview_time',
            action: :schedule,
            as: :schedule
        get 'interview_now'
      end
    end
    member do
      get 'select_location/:back_to_confirm', action: :select_location, as: :select_location
      get 'set_location_area/:location_area_id/:back_to_confirm', action: :set_location_area, as: :set_location_area
      get :send_paperwork, action: :send_paperwork, as: :send_paperwork
      get :new_sms_message, as: :new_sms_message
      post :create_sms_message, as: :create_sms_message
      get :confirm, as: :confirm
      post :record_confirmation, as: :record_confirmation
      put :record_assessment_score, as: :record_assessment_score
      get :resend_assessment, as: :resend_assessment
      get :dismiss
      patch :reactivate
      post :cant_make_training_location
      put :set_sprint_radio_shack_training_session, as: :set_sprint_radio_shack_training_session
      put :set_training_session_status
      put :set_reconciliation_status
    end
    collection do
      get :dashboard, as: :dashboard
      get :support_search, as: :support_search
      post 'support_search/:enable_filter', action: :support_search, as: :support_search_filter
    end
    resources :interview_answers, only: [:new, :create]
    resources :candidate_contacts, only: [:create] do
      collection do
        get 'new_call', action: :new_call, as: :new_call
        put :save_call_results, as: :save_call_results
      end
    end
    resources :candidate_scheduling_dismissals, only: [:new, :create]
  end

  resources :changelog_entries, only: [:index, :new, :create]

  namespace :client_access do
    resources :worker_assignments, controller: 'workmarket_assignments', only: [:index, :show, :destroy] do
      collection do
        get :csv, as: :csv, defaults: { format: :csv }
      end
    end
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
      resources :locations, only: [:new, :create, :index, :show]
    end
    member do
      get :sales, as: :sales
    end
  end

  resources :client_representatives do
    collection do
      get :new_session, as: :new_session
      post :create_session, as: :create_session
      get :welcome, as: :welcome
      delete :destroy_session, as: :destroy_session
    end
  end

  resources :comcast_customers, except: [:edit, :update, :destroy] do
    resources :comcast_customer_notes, only: [:create]
    resources :comcast_sales, only: [:new, :create]
    resources :comcast_leads, only: [:new, :create, :edit, :update, :destroy] do
      member do
        get :reassign, to: 'comcast_leads#reassign', as: :reassign
        patch 'reassign_to/:person_id', to: 'comcast_leads#reassign_to', as: :reassign_to
      end
    end
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
    resources :positions, only: [:index] do
      member do
        get :edit_permissions, as: :edit_permissions
        put :update_permissions, as: :update_permissions
      end
    end
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

  resources :directv_customers, except: [:edit, :update, :destroy] do
    resources :directv_customer_notes, only: [:create]
    resources :directv_sales, only: [:new, :create]
    resources :directv_leads, only: [:new, :create, :edit, :update, :destroy] do
      member do
        get :reassign, to: 'directv_leads#reassign', as: :reassign
        patch 'reassign_to/:person_id', to: 'directv_leads#reassign_to', as: :reassign_to
      end
    end
  end

  resources :directv_eods, only: [:new, :create]
  resources :directv_leads, only: [:index] do
    collection do
      get :csv, to: 'directv_leads#csv', as: :csv, defaults: { format: :csv }
    end
  end
  resources :directv_sales, only: [:index] do
    collection do
      get :csv, to: 'directv_sales#csv', as: :csv, defaults: { format: :csv }
    end
  end

  post 'docusign_connect', to: 'docusign_connect#incoming'

  get 'global_search', to: 'global_search#results', as: :global_search

  post 'group_me_bot/message', to: 'group_mes#incoming_bot_message'
  get 'group_me_groups/new_post', to: 'group_me_groups#new_post', as: :new_post_group_me_groups
  post 'group_me_groups/post', to: 'group_me_groups#post', as: :post_group_me_groups

  get 'interview_schedules/:schedule_date', to: 'interview_schedules#index', as: :interview_schedules

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

  resources :people, except: [:edit, :destroy] do
    resource :screening, only: [:edit, :update]
    resources :docusign_noses, only: [:new, :create] do
      collection do
        get :new_third_party, as: :new_third_party
        post :create_third_party, as: :create_third_party
      end
    end
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
      get 'new/:candidate_id', to: 'people#new', as: :new_from_candidate
    end
  end

  get 'sessions/destroy', as: 'logout'

  resources :sms_daily_checks, only: [:index, :create, :update]

  post 'sprint_group_me_bots/message', to: 'sprint_group_me_bots#message'

  resources :sprint_sales, only: [:index] do
    collection do
      get :scoreboard, as: :scoreboard
    end
  end

  resources :training_class_types

  post 'twilio/incoming_voice', as: 'incoming_voice_twilio'
  post 'twilio/incoming_sms', as: 'incoming_sms_twilio'


  # ------------------------- API NAMESPACE --------------------------

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'people/onboard/:connect_user_id', to: 'people#onboard', as: 'api_onboard'
      get 'people/separate/:connect_user_id', to: 'people#separate', as: 'api_separate'
      get 'people/update/:connect_user_id', to: 'people#update', as: 'api_update'
      get 'projects/:project_id/locations/:zip', to: 'locations#nearby_zip_for_project', as: 'api_locations_nearby_zip_for_project'
    end
  end

  get '*unmatched_route', to: 'root_redirects#no_route'
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
