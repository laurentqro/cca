class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Authorization

  impersonates :user

  prepend_view_path Rails.root.join("frontend")
end
