class VolunteerMailer < ApplicationMailer
  default from: 'admin@where2help.at'

  def notify_volunteers(need)
    @volunteers = User.where.not(ngo_admin: true)
    @need = need
    @url = 'http://where2help.at'
    mail(to: @volunteers.map(&:email), subject: "Wir brauchen dir am #{need.location}!")
  end

end
