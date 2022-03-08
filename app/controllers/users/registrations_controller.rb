class Users::RegistrationsController < Devise::RegistrationsController
  invisible_captcha only: :create, scope: :user, honeypot: :username

  before_action :configure_sign_up_params, only: [:create]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    if params[:user][:password].present?
      configure_account_update_params
      super
    else
      if resource.update_without_password(update_params)
        redirect_to edit_user_registration_url, notice: t("devise.registrations.updated")
      else
        render :edit
      end
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:email, :password, :password_confirmation, :first_name, :last_name,
        :phone, :terms_and_conditions,
        ability_ids: [], language_ids: [])
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      user_params.permit(
        :email,
        :first_name,
        :last_name,
        :phone,
        :locale,
        :current_password,
        :password,
        :password_confirmation,
        ability_ids: [],
        language_ids: [],
      )
    end
  end

  def update_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name,
      :phone,
      :locale,
      ability_ids: [],
      language_ids: []
    )
  end

  def after_update_path_for(_resource)
    edit_user_registration_path
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
