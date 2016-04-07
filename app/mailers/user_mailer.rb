class UserMailer < ApplicationMailer
  default from: 'no-reply@where2help.at'

  def shift_destroyed(shift, user)
    @shift = shift
    @user = user
    I18n.with_locale(@user.locale) do
      mail.to(@user.email)
    end
  end
end
