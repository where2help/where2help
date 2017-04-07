class UserNotifier
  attr_reader :user
  def initialize(user)
    @user = user
  end

  def notify
    # if user has notifications off
    #   return
    # if user has messenger turned on
    #   notify bot
    # if user has email turned on
    #   notify via email
  end
end
