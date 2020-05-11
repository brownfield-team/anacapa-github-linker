Rails.application.routes.draw do
  # resources :roster_students
  # devise routes
  devise_for :users, :controllers => {
      :omniauth_callbacks => "users/omniauth_callbacks#github"
  }
  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :signout
  end

  # courses routes
  # post 'courses/:course_id/join' => 'courses#join', :as => :join_course
  # post 'courses/:course_id/leave' => 'courses#leave', :as => :leave_course
  resources :courses do
    post :join
    get :jobs
    get :repos
    get :search_repos
    post :run_course_job
    post :update_ta
    scope module: :courses do
      resources :roster_students do
        collection do
          post :import
        end
      end
      resources :teams do
        collection do
          get :create_repos
          post :generate_repos
          get :create_teams
          post :generate_teams
        end
      end
      resource :github_webhooks, :only => [:create], :defaults => {:format => :json} do

      end
      # While this is somewhat frowned upon in Rails convention, I refuse to name the controller "SlacksController"
      resource :slack, :controller => 'slack'
    end
  end

  namespace :slack, path: 'slack' do
    resource :auth, :controller => 'auth', :only => [] do
      get :callback
    end
    resource :commands, :only => [] do
      post :whois
    end
  end

  resources :users

  # Admin management dashboard
  resource :admin, :controller => 'admin', :only => [] do
    get :dashboard
    post :run_admin_job
  end

  # home page routes
  resources :visitors # NOTE that this defines a number of unused routes that would be good to remove for security
  root :to => "visitors#index"
end
