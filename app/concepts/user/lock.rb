# frozen_string_literal: true

class UserOperation
  class Lock < Operation
    def process(params)
      user = params[:user]
      user.lock_access!
    end
  end

  class Unlock < Operation
    def process(params)
      user = params[:user]
      user.unlock_access!
    end
  end
end
