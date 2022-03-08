class Ngos::RegistrationsController < Devise::RegistrationsController
  invisible_captcha only: :create, scope: :ngo, honeypot: :username

  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    if params[:ngo][:password].present?
      configure_account_update_params
      super
    else
      if resource.update_without_password(update_params)
        redirect_to edit_ngo_registration_url, notice: t("devise.registrations.updated")
      else
        render :edit
      end
    end
  end

  # DELETE /resource
  def destroy
    if resource.destroy
      super
    else
      render :edit
    end
  end

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
    devise_parameter_sanitizer.permit(:sign_up) do |ngo_params|
      ngo_params.permit(
        :name,
        :email,
        :password, :password_confirmation,
        :terms_and_conditions,
        contact_attributes: [
          :email,
          :phone,
          :first_name,
          :last_name,
          :street,
          :zip,
          :city,
        ]
      )
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update) do |ngo_params|
      ngo_params.permit(
        :email,
        :password, :password_confirmation, :current_password,
        :locale,
        :name,
        :terms_and_conditions,
        contact_attributes: [:first_name, :last_name, :email, :phone, :street, :zip, :city, :id]
      )
    end
  end

  def full_devise_params
  end

  def update_params
    params.require(:ngo).permit(
      :email,
      :locale,
      :name,
      :terms_and_conditions,
      contact_attributes: [:first_name, :last_name, :email, :phone, :street, :zip, :city, :id]
    )
  end

  def after_update_path_for(_resource)
    edit_ngo_registration_path
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
