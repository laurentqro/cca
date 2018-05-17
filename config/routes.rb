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
    },
    path: 'auth'

  mount Sidekiq::Web => '/sidekiq'
  mount Shrine.presign_endpoint(:cache) => '/presign'

  root to: 'projects#index'

  namespace :api do
    resources :users, only: :index
    resources :projects, path: 'projets' do
      resources :assignments, only: [:index, :create, :destroy], path: 'membres'
      get 'assignable-users', to: 'assignments#assignable_users'
    end
  end

  resources :users,
    path: 'utilisateurs',
    path_names: { new: 'creer', edit: 'editer' } do
      post :impersonate, on: :member, path: 'imitation'
      post :stop_impersonating, on: :collection, path: 'stop-imitation'
    end

  resources :companies, path: 'groupes', path_names: { new: 'creer', edit: 'editer' }, except: :destroy do
    resources :employments, only: [:index, :create, :destroy], path: 'membres'
  end

  resources :projects, path: 'projets', path_names: { new: 'creer', edit: 'editer' } do
    resources :assignments, only: :index, path: 'membres'
    resources :folders, path: 'dossiers'
    resources :subscriptions
  end

  resources :documents
  resources :archives, only: [:index, :create, :destroy]
end
