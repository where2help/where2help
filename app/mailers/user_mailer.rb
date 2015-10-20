class UserMailer < ApplicationMailer
  default from: 'no-reply@where2help.at'

  def admin_confirmation(user)
    mail(to: user.email, subject: 'Ihr Konto ist jetzt freigeschalten')
  end
end
