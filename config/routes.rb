Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks#github" }
  resources :courses
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :visitors

  root "visitors#index"  

  # This is supposed to handle signout but for some reason it does not like this
  # chunk of code.
  # devise_scope :user do
  #   delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  # end

end
