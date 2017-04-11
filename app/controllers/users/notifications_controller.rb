class Users::NotificationsController < ApplicationController
  #before_action :authenticate_user!

  def edit
    @settings = User::Settings.new(current_user)
  end

  def update
    UserOperation::UpdateNotifications.(notification_settings: params, current_user: current_user)
    redirect_to :back, notice: t(".successful")
  end
end
