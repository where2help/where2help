class Event::Block
  def self.toggle(user_id:, ngo:)
    user = User.includes(:blocks).find(user_id)
    if user.blocked_by?(ngo)
      block = user.blocks.find { |block| block.ngo_id == ngo.id }
      block && block.destroy
    else
      NgoUserBlock.create(user: user, ngo: ngo)
    end
  end

  def self.blocked_non_participant?(user_id:, event:)
    is_participating = Participation
      .joins(shift: :event)
      .where(shifts: { event_id: event.id }, user_id: user_id)
      .count > 0
    return false if is_participating

    blocked?(user_id, event.ngo_id)
  end

  def self.blocked_ongoing_non_participant?(user_id:, event:)
    is_participating = Participation
      .where(ongoing_event_id: event.id, user_id: user_id)
      .count > 0
    return false if is_participating

    blocked?(user_id, event.ngo_id)
  end

  private

  def self.blocked?(user_id, ngo_id)
    NgoUserBlock.where(user_id: user_id, ngo_id: ngo_id).count > 0
  end
end
