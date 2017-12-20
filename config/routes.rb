require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  mount Shrine.presign_endpoint(:cache) => '/presign'

  root to: 'activities#index'

  get    '/connexion',   to: 'sessions#new',     as: 'new_session'
  post   '/connexion',   to: 'sessions#create',  as: 'sessions'
  delete '/deconnexion', to: 'sessions#destroy', as: 'session'

  resources :users,     path: 'utilisateurs', path_names: { new: 'creer', edit: 'editer' }

  resources :projects,  path: 'projets',      path_names: { new: 'creer', edit: 'editer' } do
    resources :assignments, only: [:index, :create, :destroy], path: 'membres'
    resources :folders, path: 'dossiers'
    resources :subfolders
  end

  resources :documents
  resources :archives, only: [:index, :create, :destroy]
end
