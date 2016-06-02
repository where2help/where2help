class Api::V1::UsersController < Api::V1::ApiController

  attr_accessor :resource

  skip_before_action :api_authenticate, only: [:login, :create, :send_reset, :resend_confirmation]
  skip_before_action :set_token_header, only: [:login, :create, :send_reset, :resend_confirmation]

  # wget --header="Authorization: Token token=scWTF92WXNiH2WhsjueJk4dN" --method=delete -S http://localhost:3000/api/v1/users/unregister
  def unregister
    current_user.update(confirmation_token:    nil,
                        confirmed_at:          nil,
                        confirmation_sent_at:  nil,
                        admin:                 false,
                        api_token:             nil,
                        api_token_valid_until: nil,
                        phone:                 nil)
    render json: {deleted: true}, status: :ok
  end


  # wget --post-data="email=jane@doe.com&password=supersecret" -S http://localhost:3000/api/v1/users/login
  def login
    @user = User.find_by(email: params[:email])

    unless @user
      render json: {logged_in: false}, status: :not_found
      return
    end

   unless @user.confirmed_at.present?
      render json: {logged_in: false, user: "not_confirmed"}, status: :forbidden
      return
    end

    unless @user.valid_password?(params[:password])
      render json: {logged_in: false, password: "wrong"}, status: :unauthorized
      return
    end

    sign_in(@user)
    @user.regenerate_api_token
    @user.update(api_token_valid_until: Time.now + TOKEN_VALIDITY)
    response.headers['TOKEN'] = @user.api_token
    render :show
  end


  # wget --header="Authorization: Token token=scWTF92WXNiH2WhsjueJk4dN" -S http://localhost:3000/api/v1/users/logout
  def logout
    if current_user.update(api_token: nil, api_token_valid_until: nil)
      render json: {logged_out: true}, status: :ok
    else
      render json: current_user.errors.messages, status: :bad_request
    end
  end


  # wget --header="Authorization: Token token=scWTF92WXNiH2WhsjueJk4dN" --post-data="password=mynewpassword&password_confirmation=mynewpassword" -S http://localhost:3000/api/v1/users/change_password
  def change_password
    if params[:password] == params[:password_confirmation]
      current_user.password = params[:password]
      current_user.password_confirmation = params[:password_confirmation]
      if current_user.save
        render json: {password_changed: true}, status: :ok
      else
        render json: current_user.errors.messages, status: :bad_request
      end
    else
      render json: {passwords: "not_matching"}, status: :not_acceptable
    end
  end

  # wget --post-data="user[first_name]=my_first_name&user[last_name]=my_last_name&user[email]=my@email.address&user[locale]=de&user[password]=my_password&user[password_confirmation]=my_password&user[ability_ids][]=5&user[language_ids][]=1&user[language_ids][]=3" --header="Authorization: Token token=Vh4AdGc6LWW7piG7k1FpRugm" -S http://localhost:3000/api/v1/users/update_profile
  def update_profile
    request.session_options[:skip] = true

    if current_user.update_attributes(user_params)
      render json: {profile_updated: true}, status: :ok
    else
      render json: current_user.errors.messages, status: :bad_request
    end
  end



  # wget --post-data="email=jane@doe.com" -S http://localhost:3000/api/v1/users/send_reset
  def send_reset
    @user = User.find_by(email: params[:email])
    if @user
      @user.send_reset_password_instructions
      render json: {password_reset: "sent"}, status: :ok
    else
      render json: {error: "user_not_found"}, status: :not_found
    end
  end


  # wget --post-data="email=jane@doe.com" -S http://localhost:3000/api/v1/users/resend_confirmation
  def resend_confirmation
    @user = User.find_by(email: params[:email])
    if @user
      @user.send_confirmation_instructions
      render json: {password_reset: "sent"}, status: :ok
    else
      render json: {error: "user_not_found"}, status: :not_found
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :locale, :password, :password_confirmation, :phone,
      language_ids: [], ability_ids: [])
  end
end
