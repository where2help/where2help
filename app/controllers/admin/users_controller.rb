class Admin::UsersController < ApplicationController
  before_action :only_admin
  before_action :set_user, except: [:index]

  def index
    @users = User.all.page(params[:page])
  end

  def update
    if @user.update_without_password(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: 'User was successfully destroyed.'
  end

  def confirm
    if @user.toggle(:admin_confirmed).save
      if @user.admin_confirmed?
        UserMailer.admin_confirmation(@user).deliver_later
        flash[:notice] = 'User was successfully confirmed.'
      else
        flash[:notice] = 'User was successfully locked.'
      end
      redirect_to @user
    else
      render :edit
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params[:user].permit(:email,
                         :first_name,
                         :last_name,
                         :organization,
                         :phone,
                         :admin,
                         :ngo_admin)
  end
end
