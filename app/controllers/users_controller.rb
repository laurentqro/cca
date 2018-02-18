class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new

    4.times do
      @user.employments.build
    end
  end

  def create
    password = SecureRandom.hex
    password_params = { password: password }
    @user = User.new(user_params.merge(password_params))

    if @user.save
      redirect_to users_url, notice: 'Utilisateur créé avec succès.'
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
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
    user = User.find(params[:id])
    user.destroy
    redirect_to users_url, notice: "Compte utilisateur supprimé."
  end

  def impersonate
    user = User.find(params[:id])
    impersonate_user(user)
    redirect_to root_path
  end

  def stop_impersonating
    stop_impersonating_user
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:email,
                                 :first_name,
                                 :last_name,
                                 :city,
                                 :active,
                                 :group,
                                 employments_attributes: [:company_id, :user_id])
  end
end
