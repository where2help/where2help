require "rails_helper"

describe Chatbot::FacebookUser do
  let (:user) {
    attrs = {
      first_name: "aaron",
      last_name: "cruz",
      locale: "en_US",
      timezone: 2,
      profile_pic: "https://foo.bar/face.png",
      gender: "female",
      is_payment_enabled: false,
      last_ad_referal: nil
    }
    Chatbot::FacebookUser.new(attrs)
  }

  it "initializes new user" do
    expect(user.first_name).to eq("aaron")
    expect(user.gender).to eq("female")
  end

  it "gets proper w2h locale" do
    expect(user.w2h_locale).to eq("en")
  end
end
