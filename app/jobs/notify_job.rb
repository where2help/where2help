class NotifyJob
  include SuckerPunch::Job

  def perform(event)
    #Log.new(event).track
    Rails.logger.debug event
  end
end
