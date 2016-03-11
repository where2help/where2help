class Api::V1::ShiftsController < Api::V1::ApiController
  
  # wget --header="Authorization: Token token=scWTF92WXNiH2WhsjueJk4dN" --post-data="shift_id=1" -S http://localhost:3000/api/v1/shifts/opt_in
  def opt_in
    @shiftsuser = ShiftsUser.create(user_id: current_user.id, shift_id: params[:shift_id])
    if @shiftuser.persisted?
      render json: {opted_id: true}, status: :ok
    else   
      render json: {@shiftsuser.errors.messages}, status: :bad_request
    end
  end


  # wget --header="Authorization: Token token=scWTF92WXNiH2WhsjueJk4dN" --post-data="shift_id=1" -S http://localhost:3000/api/v1/shifts/opt_out
  def opt_out
    @shiftsuser = ShiftsUser.find_by(user_id: current_user.id, shift_id: params[:shift_id])
    if @shiftsuser
      if @shiftsuser.destroy
        render json: {opted_out: true}, status: :ok
      else
      render json: {@shiftsuser.errors.messages}, status: :bad_request       
    else
      render json: {opted_out: false}, status: :not_found
    end
  end
end