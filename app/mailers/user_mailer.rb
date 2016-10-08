class UserMailer < ApplicationMailer
  def shift_destroyed(shift, user)
    @shift = shift
    @user = user
    I18n.with_locale(@user.locale) do
      mail.to(@user.email)
    end
  end

  def shift_updated(shift, user)
    @shift = shift
    @user = user
    I18n.with_locale(@user.locale) do
      mail.to(@user.email)
    end
  end
end
