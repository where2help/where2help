class Admin::UsersController < ApplicationController
  before_action :only_admin

  def index
    @users = User.all.page(params[:page])
  end

  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def admin_confirm
    @user = User.find(params[:id])
    if @user.toggle(:admin_confirmed).save && @user.admin_confirmed?
      UserMailer.admin_confirmation(@user).deliver_later
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    # if current_user.admin?
    #   @user = User.find(params[:id])
    # else
      @user = current_user
    #end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params[:user].permit(:email,
                         :first_name,
                         :last_name,
                         :password,
                         :password_confirmation,
                         :phone,
                         :admin,
                         :ngo_admin)
  end
end
