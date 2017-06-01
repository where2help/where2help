class Notification::Unsent
  def self.call
    Rails.logger.info("Checking if we have any unsent messages for users")

    nots = Notification::Repo.new.unsent.group(:user_id)
    require 'pry'
    require 'pry-byebug'
    binding.pry
  end
end
