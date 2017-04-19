require "rails_helper"

require "chatbot/brain"

describe Chatbot::Brain do
  context "#handle_text_message hello" do
    it "handles english locale" do
      fb_id  = "facebook_id"
      locale = "en"
      text   = I18n.t("chatbot.user_hello", locale: locale).sample
      user   = create(:user, locale: locale)
      user.create_facebook_account(facebook_id: fb_id)
      sender = Struct.new(:id).new(fb_id)
      msg    = Struct.new(:sender, :text).new(sender, text)
      expected_responses = I18n.t("chatbot.hello", locale: locale)
      described_class.new.handle_text_message(msg)
      response = BotMessage.where(from_bot: true).first.payload
      expect(expected_responses).to include(response)
    end

    it "handles german locale" do
      fb_id  = "facebook_id"
      locale = "de"
      text   = I18n.t("chatbot.user_hello", locale: locale).sample
      user   = create(:user, locale: locale)
      user.create_facebook_account(facebook_id: fb_id)
      sender = Struct.new(:id).new(fb_id)
      msg    = Struct.new(:sender, :text).new(sender, text)
      expected_responses = I18n.t("chatbot.hello", locale: locale)
      described_class.new.handle_text_message(msg)
      response = BotMessage.where(from_bot: true).first.payload
      expect(expected_responses).to include(response)
    end
  end

  context "#handle_text_message fallback" do
    it "falls back to a do not understand response when it doesn't understand" do
      fb_id  = "facebook_id"
      locale = "de"
      text   = "foobazboooooooo"
      user   = create(:user, locale: locale)
      user.create_facebook_account(facebook_id: fb_id)
      sender = Struct.new(:id).new(fb_id)
      msg    = Struct.new(:sender, :text).new(sender, text)
      expected_responses = I18n.t("chatbot.dont_understand", locale: locale)
      described_class.new.handle_text_message(msg)
      response = BotMessage.where(from_bot: true).first.payload
      expect(expected_responses).to include(response)
    end
  end
end
