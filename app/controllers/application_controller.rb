class ApplicationController < ActionController::Base
  include ActionView::Helpers::UrlHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale, :redirect_to_login_if_possible

  def set_locale
    locale_param = I18n.available_locales.map(&:to_s).include?(params[:locale]) ? params[:locale] : nil
    I18n.locale = current_user.try(:locale) || locale_param || I18n.default_locale
  end

  def authenticate_admin!
    redirect_to root_path unless current_user.try(:admin?)
  end

  def self.default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def redirect_to_login_if_possible
    valid_roles = ['user', 'ngo']

    is_role_known = valid_roles.include?(cookies[:last_role])
    is_root_page = current_page?('/')

    if(request.get? && is_role_known && is_root_page)
      if(cookies[:last_role] == 'user')
        redirect_to new_user_session_path
      else
        redirect_to new_ngo_session_path
      end
    end
  end
end
