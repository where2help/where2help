class PagesController < ApplicationController
  before_action :redirect_to_login_if_possible, only: :home

  def home
    @user = User.new
  end

  def robots
    render format: "txt"
  end

  private

  def redirect_to_login_if_possible
    return unless request.get? && !user_signed_in?

    last_role = cookies.permanent[:last_role]
    return unless %w(user ngo).include?(last_role)

    last_redirected_to_login = session[:last_redirected_to_login]
    return if last_redirected_to_login.present? && last_redirected_to_login > 1.hour.ago.to_i

    session[:last_redirected_to_login] = Time.zone.now.to_i

    if last_role == "user"
      redirect_to new_user_session_path
    else
      redirect_to new_ngo_session_path
    end
  end
end
