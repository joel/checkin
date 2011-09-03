CheckinReloaded::Application.routes.draw do

  root :to => "people#index"
    
  resources :notifications

  resources :tokens

  devise_for :users,
             :controllers  => {
               :registrations => 'users',
               :sessions => "sessions"
             }
  
  resources :users do
    get 'current_checkin', :on => :collection
    member do
      put 'follow'
      post 'request_an_invitation'
      post 'accept_invitation'
      delete 'denied_invitation'
    end
    resources :tokens do
      collection do
        get 'add_tokens'
        post 'create_tokens'
      end
    end
    resources :check
  end

end
