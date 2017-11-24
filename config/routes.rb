require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  root to: 'pages#home'

  get    '/connexion',   to: 'sessions#new',     as: 'new_session'
  post   '/connexion',   to: 'sessions#create',  as: 'sessions'
  delete '/deconnexion', to: 'sessions#destroy', as: 'session'

  resources :users,     path: 'utilisateurs', path_names: { new: 'creer', edit: 'editer' }
  resources :projects,  path: 'projets',      path_names: { new: 'creer', edit: 'editer' } do
    resources :folders, path: 'dossiers'
  end

  resources :assignments, only: [:create, :destroy]
  resources :archives, only: [:index, :create, :destroy]
end
