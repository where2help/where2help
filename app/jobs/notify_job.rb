class NotifyJob
  include SuckerPunch::Job

  def perform(need)
    VolunteerMailer.notify_volunteers(need).deliver
  end
end
