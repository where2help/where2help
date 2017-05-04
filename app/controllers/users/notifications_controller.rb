class Users::NotificationsController < ApplicationController
  #before_action :authenticate_user!

  def edit
    @settings = User::Settings.new(current_user)
    fb_acct = current_user.facebook_account
    @pass_through_id           = fb_acct.referencing_id
    @user_has_facebook_account = fb_acct.facebook_id.present?
  end

  def update
    UserOperation::UpdateNotifications.(notification_settings: params, current_user: current_user)
    redirect_to :back, notice: t(".successful")
  end
end
