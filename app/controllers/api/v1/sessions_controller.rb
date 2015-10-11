module Api
  module V1
    class SessionsController < JSONAPI::ResourceController      
      before_filter :ensure_params_exist

      respond_to :json
      
      def create
        build_resource
        resource = User.where(email: params[:email])

        unless resource
          resource = User.new(email: params[:email], phone: params[:phone])
          resource.save(validate: false)

          render :json=> {:success=>true, :auth_token=>resource.authentication_token, :login=>resource.login, :email=>resource.email}
          return
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
  end
end