require "rails_helper"

require "chatbot/client"

describe Chatbot::Client do
  let(:cli) { described_class.new }

  before(:each) do
    allow(cli).to receive(:log_res)
  end

  context "#send_text" do
    it "sends a text message to the user" do
      msg     = "hi there"
      fb_id   = "1234"
      fb_acct = OpenStruct.new(facebook_id:      fb_id)
      user    = OpenStruct.new(facebook_account: fb_acct)
      expect(cli.client).to receive(:text).with(recipient_id: fb_id, text: msg)
      cli.send_text(user, msg)
    end

    it "exits if no facebook id exists" do
      msg     = "hi there"
      user    = OpenStruct.new(facebook_account: nil)
      expect(cli.client).not_to receive(:text)
      cli.send_text(user, msg)
    end

    it "records the message sent to the user" do
      msg     = "hi there"
      fb_id   = "1234"
      fb_acct = FacebookAccount.create(facebook_id: fb_id)
      user    = OpenStruct.new(facebook_account: fb_acct)
      expect {
        cli.send_text(user, msg)
      }.to change(BotMessage, :count).by(1)
    end

    it "doesn't create a bot message if it can't find the facebook id" do
      msg     = "hi there"
      fb_id   = "1234"
      fb_acct = OpenStruct.new(facebook_id:      fb_id)
      user    = OpenStruct.new(facebook_account: fb_acct)
      expect {
        cli.send_text(user, msg)
      }.to change(BotMessage, :count).by(0)
    end
  end

  context "#text" do
    it "records the message sent to the id" do
      msg     = "hi there"
      fb_id   = "1234"
      FacebookAccount.create(facebook_id: fb_id)
      expect {
        cli.text(fb_id, msg)
      }.to change(BotMessage, :count).by(1)
    end

    it "doesn't create message if no fb account exists" do
      msg     = "hi there"
      fb_id   = "1234"
      expect {
        cli.text(fb_id, msg)
      }.to change(BotMessage, :count).by(0)
    end
  end
end
