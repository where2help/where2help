class Users::NotificationsController < ApplicationController
  #before_action :authenticate_user!

  def edit
    @settings = User::Settings.new(current_user)
    @pass_through_id = current_user.facebook_account.referencing_id
  end

  def update
    UserOperation::UpdateNotifications.(notification_settings: params, current_user: current_user)
    redirect_to :back, notice: t(".successful")
  end
end
