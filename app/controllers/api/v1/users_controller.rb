class Api::V1::UsersController < Api::V1::ApiController

  attr_accessor :resource


  # wget --header="Authorization: Token token=scWTF92WXNiH2WhsjueJk4dN" --method=delete -S http://localhost:3000/api/v1/users/unregister
  def unregister
    current_user.update(confirmation_token:    nil,
                        confirmed_at:          nil,
                        confirmation_sent_at:  nil,
                        admin:                 false,
                        api_token:             nil,
                        api_token_valid_until: nil)
    render json: {deleted: true}, status: :ok
  end


  # wget --header="Authorization: Token token=scWTF92WXNiH2WhsjueJk4dN" -S http://localhost:3000/api/v1/users/logout
  def logout
    current_user.update(api_token: nil, api_token_valid_until: nil)
    render json: {logged_out: true}, status: :ok
  end


  # wget --header="Authorization: Token token=scWTF92WXNiH2WhsjueJk4dN" --post-data="password=mynewpassword&password_confirmation=mynewpassword" -S http://localhost:3000/api/v1/users/change_password
  def change_password
    if params[:password] == params[:password_confirmation]
      current_user.password = params[:password]
      current_user.password_confirmation = params[:password_confirmation]
      if current_user.save
        render json: {password_changed: true}, status: :ok
      else
        render json: {password_changed: false}, status: :unprocessable_entity
      end
    else
      render json: {passwords: "not_matching"}, status: :unprocessable_entity
    end
  end


  # wget --post-data="email=jane@doe.com" -S http://localhost:3000/api/v1/users/send_reset
  def send_reset
    @user = User.find_by(email: params[:email])
    if @user
      @user.send_reset_password_instructions
      render json: {password_reset: "sent"}, status: :ok
    else
      render json: {error: "user_not_found"}, status: :ok
    end      
  end


  # wget --post-data="email=jane@doe.com" -S http://localhost:3000/api/v1/users/resend_confirmation
  def resend_confirmation
    @user = User.find_by(email: params[:email])
    if @user
      @user.send_confirmation_instructions
      render json: {password_reset: "sent"}, status: :ok
    else
      render json: {error: "user_not_found"}, status: :ok
    end
  end
end
