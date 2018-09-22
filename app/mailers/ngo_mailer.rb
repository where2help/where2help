class NgoMailer < ApplicationMailer
  def admin_confirmed(ngo)
    @ngo = ngo
    I18n.with_locale(@ngo.locale) do
      mail.to(@ngo.email)
    end
  end

  def ongoing_event_opt_in(ngo:, ongoing_event:, user:)
    @ngo = ngo
    @ongoing_event = ongoing_event
    @user = user

    ongoing_event_title = truncate_event_title(ongoing_event.title)
    subject = default_i18n_subject(ongoing_event_title: ongoing_event_title)

    I18n.with_locale(@ngo.locale) do
      mail(to: @ngo.email, subject: subject)
    end
  end

  private

    def truncate_event_title(event_title)
      ActionController::Base.helpers.truncate(event_title, length: 40)
    end
end
