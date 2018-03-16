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
      flash[:notice] = 'Utilisateur créé avec succès.'
      flash[:class] = 'success'
      redirect_to users_url
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
      flash[:class] = 'success'
      flash[:notice] = 'Modifications enregistrées.'
      redirect_to user
    else
      render :edit
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:class] = 'success'
    flash[:notice] = 'Compte utilisateur supprimé.'
    redirect_to users_url
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
