class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # params for sign_up
  before_action :store_resource_return_to
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :set_locale

  protected

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email,
              :first_name,
              :last_name,
              :phone,
              :password,
              :password_confirmation,
              :terms_and_conditions,)
    end
  end

  def after_sign_in_path_for(resource)
    if session[:resource_return_to]
      session.delete(:resource_return_to) 
    else
      if resource.ngo_admin?
        calendar_ngos_needs_path
      else
        admin_needs_path
      end
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def only_admin
    unless current_user && current_user.admin?
      redirect_to new_user_session_path, alert: "Nicht erlaubt!"
    end
  end

  def only_ngo_admin
    unless current_user && (current_user.ngo_admin? || current_user.admin)
      redirect_to new_user_session_path, alert: "Nicht erlaubt!"
    end
  end

  def store_resource_return_to
    unless user_signed_in? || request.fullpath == "/users/sign_in"
      session[:resource_return_to] = request.fullpath
    end
  end
end