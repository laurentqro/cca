class SessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    redirect_to root_url if logged_in?
  end

  def create
    @user = User.fetch_by_username_or_email(params[:session][:identifier])

    if @user && @user.authenticate(params[:session][:password])
      log_in(@user)
      redirect_to after_sign_in_path, notice: 'Vous êtes connecté(e)'
    else
      flash[:notice] = 'Identifiant ou mot de passe incorrect'
      render :new
    end
  end

  def destroy
    logout
    redirect_to new_session_url
  end

  private

  def after_sign_in_path
    session['return_to'] || root_url
  end
end
