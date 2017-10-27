Rails.application.routes.draw do
  root to: 'pages#home'

  get    '/connexion',   to: 'sessions#new', as: 'log_in'
  post   '/connexion',   to: 'sessions#create'
  delete '/deconnexion', to: 'sessions#destroy', as: 'log_out'

  resources :users, path: 'utilisateurs', path_names: { new: 'creer', edit: 'editer' }
end
