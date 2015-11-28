module Api
  module V1
    class VolunteeringsController < ApiController
      def update
        if context[:current_user].id == Volunteering.find(params[:id]).user.id
          super
        else
          render json: {error: 'Forbidden'}, :status => 403
        end
      end   
      
      def destroy
        if context[:current_user].id == Volunteering.find(params[:id]).user.id
          super
        else
           render json: {error: 'Forbidden'}, :status => 403
        end
      end    
    end
  end
end
