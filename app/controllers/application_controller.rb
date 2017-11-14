class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :store_location!
  before_action :authenticate_user!
  before_action :authorize

  delegate :allow_action?, to: :current_permission
  helper_method :allow_action?

  delegate :allow_param?, to: :current_permission
  helper_method :allow_param?

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

  def current_permission
    @current_permission ||= Permission.new(current_user)
  end

  def current_resource
    nil
  end

  def authorize
    if current_permission.allow_action?(params[:controller], params[:action], current_resource)
      current_permission.permit_params!(params)
    else
      redirect_back(fallback_location: root_url, notice: "Accès non autorisé")
    end
  end
end
