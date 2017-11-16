Rails.application.routes.draw do
  resources :courses
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :visitors

  root "visitors#index"

  get '/signin' => 'sessions#new', :as => :signin
end
