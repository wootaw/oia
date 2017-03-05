Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, controllers: {
    sessions: 'user/sessions'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resources :documents
  resources :users do
    collection do
      get :exists
    end
  end
  
  namespace :api do
    namespace :v1 do
      resources :documents
    end
  end

  match "/:login" => "users#show", via: [:get]
  match "/:login/:project_name" => "projects#index", via: [:get]
  match "/:login/:project_name/:resource_key" => "projects#index", via: [:get]
end
