class AdminMailer < ApplicationMailer
  default from: 'no-reply@where2help.at',
          to: Proc.new { User.where(admin: true).pluck(:email) }

  def ngo_confirmation_request(user)
    @user = user
    mail(subject: default_i18n_subject(organization: @user.organization))
  end
end
