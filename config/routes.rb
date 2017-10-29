Rails.application.routes.draw do
  root to: 'pages#home'

  get    '/connexion',   to: 'sessions#new',     as: 'new_session'
  post   '/connexion',   to: 'sessions#create',  as: 'sessions'
  delete '/deconnexion', to: 'sessions#destroy', as: 'session'

  resources :users,     path: 'utilisateurs', path_names: { new: 'creer', edit: 'editer' }
  resources :projects,  path: 'projets',      path_names: { new: 'creer', edit: 'editer' }
  resources :assignments, only: [:create, :destroy]
end
