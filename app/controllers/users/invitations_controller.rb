# frozen_string_literal: true

class Users::InvitationsController < Devise::InvitationsController
  before_action :configure_permitted_parameters

  def new
    super
  end

  def create
    super
  end

  def edit
    super
  end

  def update
    email_admin
    super
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: [:first_name, :last_name, :company_id, :group, :city])
  end

  def email_admin
    invitee = User.find_by_invitation_token(params[:user][:invitation_token], true)
    UserMailer.invitation_accepted(invitee).deliver_now
  end
end
