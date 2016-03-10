class Api::V1::ShiftsController < Api::V1::ApiController
  
  # wget --header="Authorization: Token token=scWTF92WXNiH2WhsjueJk4dN" --post-data="shift_id=1" -S http://localhost:3000/api/v1/shifts/opt_in
  def opt_in
    if ShiftsUser.create(user_id: current_user.id, shift_id: params[:shift_id]).persisted?
      render json: {opted_id: true}, status: :ok
    else   
      render json: {opted_id: false}, status: :ok
    end
  end


  # wget --header="Authorization: Token token=scWTF92WXNiH2WhsjueJk4dN" --post-data="shift_id=1" -S http://localhost:3000/api/v1/shifts/opt_out
  def opt_out
    if ShiftsUser.find_by(user_id: current_user.id, shift_id: params[:shift_id]).try(:destroy)
      render json: {opted_out: true}, status: :ok
    else
      render json: {opted_out: false}, status: :ok
    end
  end
end