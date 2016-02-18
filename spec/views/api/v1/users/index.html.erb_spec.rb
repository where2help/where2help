require 'rails_helper'

RSpec.describe "api/v1s/index", type: :view do
  before(:each) do
    assign(:api_v1_users, [
      Api::V1::User.create!(),
      Api::V1::User.create!()
    ])
  end

  it "renders a list of api/v1s" do
    render
  end
end
