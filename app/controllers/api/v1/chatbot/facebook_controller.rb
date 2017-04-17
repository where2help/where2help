class Api::V1::Chatbot::FacebookController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:message]

  def challenge
    op = ChatbotOperation::Challenge.(params)
    res = op.model
    if res.success
      return render status: 201, plain: res.payload
    end
    render status: 401, plain: "Unauthorized"
  end

  def message
    if verify_request_signature
      ChatbotOperation::Message.(params)
      return render plain: "OK", status: 201
    end
    render status: 401, plain: "Unauthorized"
  end

  private

  def verify_request_signature
    ::Chatbot::AuthorizeRequest.new.(request, ENV.fetch("FB_MESSENGER_APP_SECRET"))
  end
end
