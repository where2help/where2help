class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # params for sign_up
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email,
              :first_name,
              :last_name,
              :phone,
              :password,
              :password_confirmation)
    end    
  end

  def after_sign_in_path_for(resource)
    if resource.ngo_admin? || resource.admin?
      pages_calendar_path
    else
      needs_feed_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def only_admin
    unless current_user.admin?
      redirect_to new_user_session_path, alert: "Nicht erlaubt!"
    end
  end

  def only_ngo_admin
    unless (current_user.ngo_admin? or current_user.admin?)
      redirect_to new_user_session_path, alert: "Nicht erlaubt!"
    end
  end
end