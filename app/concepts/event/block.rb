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
end
