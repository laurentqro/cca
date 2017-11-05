class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.welcome_email(@user).deliver_later
      redirect_to users_url, notice: 'Compte créé avec succès.'
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    @button_label = "Valider"
  end

  def update
    user = User.find(params[:id])

    if user.update(user_params)
      redirect_to user, notice: 'Modifications enregistrées.'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url, notice: "Compte #{@user.username} supprimé."
  end

  private

  def user_params
    params.require(:user).permit(:username,
                                 :password,
                                 :email,
                                 :first_name,
                                 :last_name,
                                 :company,
                                 :city,
                                 :active
                                )
  end
end
