Rails.application.routes.draw do
  # devise routes
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks#github" }
  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :signout
  end

  # courses routes
  resources :courses
  post 'courses/:course_id/join' => 'courses#join', :as => :join_course
  post 'courses/:course_id/leave' => 'courses#leave', :as => :leave_course
  
  # home page routes
  resources :visitors
  root "visitors#index"
end
