require "rails_helper"
require "user/settings"

describe User::Settings do
  let(:user)          { FactoryGirl.create(:user) }
  let(:settings)      { User::Settings.new(user) }
  let(:fb_key)        { User::Settings::FB_NOTIFICATION_KEY }
  let(:email_key)     { User::Settings::EMAIL_NOTIFICATION_KEY }
  let(:upcoming_key)  { User::Settings::UPCOMING_EVENT_KEY }
  let(:new_event_key) { User::Settings::NEW_EVENT_KEY }

  context "#setup_new_user!" do
    it "has default nil values for settings" do
      expect(user.setting(fb_key)).to        be_nil
      expect(user.setting(email_key)).to     be_nil
      expect(user.setting(upcoming_key)).to  be_nil
      expect(user.setting(new_event_key)).to be_nil
    end

    it "adds default settings to a user" do
      settings.setup_new_user!
      expect(user.setting(fb_key)).to        eq(false)
      expect(user.setting(email_key)).to     eq(true)
      expect(user.setting(upcoming_key)).to  eq(true)
      expect(user.setting(new_event_key)).to eq(true)
    end
  end

  context "#update" do
    it "updates the user settings" do
      settings.setup_new_user!
      params = {fb_key => true, email_key => nil, upcoming_key => false}
      settings.update(params)
      expect(user.setting(fb_key)).to       eq(true)
      expect(user.setting(email_key)).to    eq(false)
      expect(user.setting(upcoming_key)).to eq(false)
    end

    it "sets values not included as false" do
      settings.setup_new_user!
      params = {fb_key => true}
      settings.update(params)
      expect(user.setting(fb_key)).to       eq(true)
      expect(user.setting(email_key)).to    eq(false)
      expect(user.setting(upcoming_key)).to eq(false)
    end
  end
end
