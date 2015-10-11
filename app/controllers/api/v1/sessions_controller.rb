class Api::SessionsController < Api::BaseController
  prepend_before_filter :require_no_authentication, :only => [:create ]
  
  before_filter :ensure_params_exist

  respond_to :json
  
  def create
    build_resource
    resource = User.where(email: params[:email])

    unless resource
      # create User on the fly
      return invalid_login_attempt
    end

    sign_in("user", resource)
    render :json=> {:success=>true, :auth_token=>resource.authentication_token, :login=>resource.login, :email=>resource.email}
  end
  
  def destroy
    sign_out(resource_name)
  end

  protected
  def ensure_params_exist
    return unless params[:email].blank?
    render :json=>{:success=>false, :message=>"Email adresse fehlt"}, :status=>422
  end

  def invalid_login_attempt
    render :json=> {:success=>false, :message=>"Fehler beim login"}, :status=>401
  end
end