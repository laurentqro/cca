require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users,
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords',
      invitations: 'users/invitations'
    },
    path_names: {
      sign_in: 'connexion',
      sign_out: 'deconnexion',
    },
    path: 'auth'

  mount Sidekiq::Web => '/sidekiq'

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
      resource :impersonation, only: [:create, :destroy], module: :users
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
end
