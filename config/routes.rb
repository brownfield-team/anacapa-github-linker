Rails.application.routes.draw do
  # resources :roster_students
  # devise routes
  devise_for :users, :controllers => { 
    # TODO: add support for additional omniauth providers
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
    post :leave 
    scope module: :courses do
      resources :roster_students, except: :index do
        collection do 
          post :import
        end
      end
    end
  end

  # home page routes
  resources :visitors # NOTE that this defines a number of unused routes that would be good to remove for security
  root :to => "visitors#index"
end
