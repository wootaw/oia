Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, controllers: {
    sessions: 'user/sessions',
    registrations: 'user/registrations'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resources :documents
  resources :projects
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

  match "/:owner_name" => "owners#show", via: [:get], as: :user_profile
  match "/:owner_name/:project_name" => "projects#index", via: [:get], as: :project_documents
  match "/:owner_name/:project_name/:resource_key" => "projects#index", via: [:get]
end
