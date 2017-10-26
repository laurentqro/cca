Rails.application.routes.draw do
  root to: 'pages#home'

  scope(path_names: { new: 'creer', edit: 'editer' }) do
      resources :users, path: 'utilisateurs'
  end
end
