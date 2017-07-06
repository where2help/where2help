require "rails_helper"

describe Chatbot::Locale do
  context ".from_facebook" do
    it "converts to rails style locale" do
      expect(Chatbot::Locale.from_facebook("en_US").locale).to eq("en")
    end

    it "returns default (en) on unknown" do
      expect(Chatbot::Locale.from_facebook("foo_BAR").locale).to eq("en")
    end
  end

  context ".from_w2h" do
    it "converts to facebook locale" do
      expect(Chatbot::Locale.from_w2h("en").facebook_locale).to eq("en_US")
    end
  end

  context ".default" do
    it "defaults to english" do
      expect(Chatbot::Locale.default.locale).to eq("en")
    end
  end
end
