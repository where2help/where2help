# frozen_string_literal: true

class Api::V1::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token # No CSRF for API needed

  helper_method "current_user", "user_signed_in?", "user_session" # so that we can use devise's methods

  before_action :api_authenticate
  before_action :set_token_header
  before_action :disable_cookies

  TOKEN_VALIDITY = 1.week

  private

  def api_authenticate
    authenticate_or_request_with_http_token do |token, _options|
      @current_user = User.where(api_token: token).where("api_token_valid_until > ?", Time.now).try(:first)
      @current_user&.regenerate_api_token # So that it's single use
      @current_user.update(api_token_valid_until: Time.now + TOKEN_VALIDITY) if current_user
    end
  end

  def set_token_header
    if @current_user
      # see http://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Token.html#method-i-token_and_options for details:
      response.headers['TOKEN'] = @current_user.api_token
    end
  end

  def disable_cookies
    request.session_options[:skip] = true
  end
end
