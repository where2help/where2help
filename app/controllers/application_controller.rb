class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale

  def set_locale
    rails "xxx"
    locale_param = I18n.available_locales.map(&:to_s).include?(params[:locale]) ? params[:locale] : nil
    I18n.locale = current_user.try(:locale) || locale_param || I18n.default_locale
  end

  def authenticate_admin!
    redirect_to root_path unless current_user.try(:admin?)
  end

  def self.default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end
end
