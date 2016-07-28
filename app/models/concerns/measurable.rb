module Measurable
  extend ActiveSupport::Concern

  def progress_bar(user=nil)
    if user && has_user(user)
      ProgressBar::Personal.new self
    else
      ProgressBar::Public.new self
    end
  end

  private

  def has_user(user)
    case self
    when Shift
      self.users.include? user
    when Event
      available_shifts.joins(:participations)
        .where(participations: { user_id: user.id }).any?
    else
      false
    end
  end
end
