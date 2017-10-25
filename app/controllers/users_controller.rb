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

    if @user.save(user_params)
      redirect_to users_url, notice: 'Compte cree avec succes.'
    else
      render :new
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url, notice: "Compte #{@user.username} supprime"
  end

  private

  def user_params
    params.require(:user).permit(:username,
                                 :password,
                                 :email,
                                 :first_name,
                                 :last_name,
                                 :company,
                                 :city
                                )
  end
end
