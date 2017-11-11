class SessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    @user = User.fetch_by_username_or_email(params[:session][:identifier])

    if @user && @user.authenticate(params[:session][:password])
      log_in(@user)
      redirect_to root_url, notice: 'Vous êtes connecté'
    else
      flash[:notice] = 'Identifiant ou mot de passe incorrect'
      render :new
    end
  end

  def destroy
    logout
    redirect_to new_session_url
  end
end
