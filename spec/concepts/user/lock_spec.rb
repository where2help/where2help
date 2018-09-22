require "rails_helper"
require "user/lock"
context "Locking and unlocking users" do
  let (:user) { create(:user) }

  describe UserOperation::Lock do
    it "should be unlocked by default" do
      expect(user.access_locked?).to be false
    end

    it "locks a user" do
      UserOperation::Lock.(user: user)
      expect(user.access_locked?).to be true
    end
  end

  describe UserOperation::Unlock do
    it "unlocks a user" do
      UserOperation::Lock.(user: user)
      UserOperation::Unlock.(user: user)
      expect(user.access_locked?).to be false
    end
  end
end
