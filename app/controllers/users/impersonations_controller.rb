class Users::ImpersonationsController < ApplicationController

  def create
    user = User.find(params[:user_id])
    impersonate_user(user)
    redirect_to root_path
  end

  def destroy
    stop_impersonating_user
    redirect_to root_path
  end
end
