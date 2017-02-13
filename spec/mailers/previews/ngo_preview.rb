# Preview all emails at http://localhost:3000/rails/mailers/ngo
class NgoPreview < ActionMailer::Preview
  def ongoing_event_opt_in
    ongoing_event = OngoingEvent.first
    NgoMailer.ongoing_event_opt_in(
      ngo: ongoing_event.ngo,
      ongoing_event: ongoing_event,
      user: User.first
    )
  end
end
