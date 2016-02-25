class Api::V1::RegistrationsController < Users::RegistrationsController
  skip_before_action :verify_authenticity_token # No CSRF for API needed
  respond_to :json

  def create
    request.session_options[:skip] = true
    params[:user] = params 
    super
  end
end