class Chatbot::Presenter
  def initialize(user, notifications)
    @locale = user.locale
    @notifications = notifications
  end

  def to_json
  end
end
