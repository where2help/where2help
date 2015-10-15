class NotifyJob
  include SuckerPunch::Job

  def perform(need)
    #Log.new(event).track
    #Rails.logger.debug event

    require 'pry'
    binding.pry
    VolunteerMailer.notify_volunteers(need).deliver
  end
end
