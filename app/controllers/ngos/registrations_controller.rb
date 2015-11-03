class Ngos::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_sign_up_params, only: [:create]

  def create
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?
    if resource.persisted?
      # enque user for confirmation
      RequestAdminConfirmation.new.async.perform(resource)
      redirect_to root_path, notice: I18n.t('devise.registrations.enqueued_for_admin_confirm')
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) do |n|
      n.permit(:email,
              :first_name,
              :phone,
              :password,
              :password_confirmation,
              :terms_and_conditions).
        merge(last_name: 'ngo',
              ngo_admin: true,
              admin_confirmed: false)
    end
  end
end
