Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks#github" }
  resources :courses
  post 'courses/:course_id/join' => 'courses#join', :as => :join_course
  post 'courses/:course_id/leave' => 'courses#leave', :as => :leave_course
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :visitors
  
  root "visitors#index"  

end
