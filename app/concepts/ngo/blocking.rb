class Ngo::Blocking
  class List < Command
    def process(ngo:)
      # Not using pagination because I am **assuming** an NGO would block so many users.
      NgoUserBlock.includes(:user).where(ngo_id: ngo.id).order(created_at: :desc)
    end
  end

  class Unblock < Operation
    def process(ngo:, block_id:)
      block = ngo.user_blocks.find(block_id)
      block.destroy
    end
  end
end
