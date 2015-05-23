ThePowerHat::Application.routes.draw do

  resources :posts

  resources :secured_messages, only: [:show]

  resources :budget

  resources :parties do
    collection do
      get :total_debts
    end
  end

  resources :users, only: [:index, :update, :show] do
    collection do
      get :autocomplete
      get :debts_matrix
      post :recount_debts
    end
    member do
      get :edit, to: :profile
    end
  end

  resources :tags, only: [] do
    collection do
      get :autocomplete
    end
  end

  resources :images, only: [:show] do
    member do
      post :upload
      get '(:version)', action: :file, as: :file
    end
  end

  controller :templates, path: "/templates", as: :templates do
    get "/:action"
  end

  root 'home#index'

  get 'profile', to: 'users#profile'
  match 'login', :via => [:post, :get], :to => 'home#login_user', :as => :login
  get 'logout', :to => 'home#logout_user', :as => :logout
  get '/auth/:provider/callback', to: 'home#omniauth_login'

  controller :home, as: :home do
    get :token
    get :profile
  end

end
