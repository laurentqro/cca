class ApplicationController < ActionController::Base
  impersonates :user

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :authorize

  delegate :allow_action?, to: :current_permission
  helper_method :allow_action?

  delegate :allow_param?, to: :current_permission
  helper_method :allow_param?

  protected

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
      flash[:notice] = "Accès non autorisé"
      flash[:class] = 'danger'
      redirect_back(fallback_location: root_url)
    end
  end
end
