CheckinReloaded::Application.routes.draw do

  root :to => "users#index"
    
  resources :notifications

  resources :tokens

  # devise_for :users, :controllers => { :sessions => "sessions" }
  devise_for :users do
    get "/users/sign_out" => "devise/sessions#destroy", :as => :destroy_user_session
  end
  
  resources :users do
    collection do
      get 'current_checkin'
      # TODO Temporary access
      get 'import'
    end
    member do
      put 'follow'
      post 'request_an_invitation'
      post 'accept_invitation'
      delete 'denied_invitation'
      get 'checkin_label'
    end
    # match 'people/:invitation_id/accept' => 'people#accept_invitation', :as => :accept
    resources :tokens do
      collection do
        get 'add_tokens'
        post 'create_tokens'
      end
    end
    resources :check
  end

end
