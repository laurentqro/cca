class SessionsController < ApplicationController
  def create
    @user = User.fetch_by_username_or_email(params[:session][:identifier])

    if @user && @user.authenticate(params[:session][:password])
      redirect_to @user, notice: 'Vous êtes connecté'
    else
      flash[:notice] = 'Identifiant ou mot de passe incorrect'
      render :new
    end
  end

  def destroy
  end
end
