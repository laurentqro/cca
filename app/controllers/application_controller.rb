class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :store_location!
  before_action :authenticate_user!

  private

  def authenticate_user!
    redirect_to new_session_url unless logged_in?
  end

  def store_location!
    session['return_to'] = request.fullpath if store_location?
  end

  def store_location?
    return false if request.fullpath =~ /\/connexion/
    return false if request.fullpath =~ /\/deconnexion/
    true
  end
end
