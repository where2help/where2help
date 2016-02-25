class AdminMailer < ApplicationMailer
  default from: 'no-reply@where2help.at',
          to: Proc.new { User.where(admin: true).pluck(:email) }

  def new_ngo(ngo)
    @ngo = ngo
    mail unless User.where(admin: true).empty?
  end
end
