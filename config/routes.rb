Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, controllers: {
    sessions: 'user/sessions',
    registrations: 'user/registrations'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  namespace :api do
    namespace :v1 do
      resources :documents
    end
  end

  resources :comments do
    collection do
      post :preview
    end
  end

  resources :documents
  resources :invitations
  resources :projects do
    collection do
      get :templates
    end
  end

  resources :resources
  resources :users do
    collection do
      get :exists
    end
  end

  match "/:owner_name" => "owners#show", via: [:get], as: :user_profile
  match "/:owner_name/:project_name" => "projects#show", via: [:get], as: :project_documents
  match "/:owner_name/:project_name/:slug" => "projects#show", via: [:get], as: :document_resources
  match "/:owner_name/:project_name/:slug/comments" => "projects#show", via: [:get], as: :resource_comments
  match "/:owner_name/:project_name/:slug/console" => "projects#show", via: [:get], as: :resource_console
end
