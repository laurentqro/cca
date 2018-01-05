require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users,
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords'
    },
    path_names: {
      sign_in: 'connexion',
      sign_out: 'deconnexion',
      sign_up: 'inscription'
    },
    path: 'auth'

  mount Sidekiq::Web => '/sidekiq'
  mount Shrine.presign_endpoint(:cache) => '/presign'

  root to: 'activities#index'

  resources :users,
    path: 'utilisateurs',
    path_names: { new: 'creer', edit: 'editer' },
    only: [:index, :show]

  resources :projects, path: 'projets', path_names: { new: 'creer', edit: 'editer' } do
    resources :assignments, only: [:index, :create, :destroy], path: 'membres'
    resources :folders, path: 'dossiers'
    resources :subfolders
  end

  resources :documents
  resources :archives, only: [:index, :create, :destroy]
end
