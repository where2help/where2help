class Chatbot::WebhooksController < ApplicationController
  def challenge
    op = ChatbotOperation::Challenge.(params)
    res = op.model
    if res.success
      return render status: 201, text: res.payload
    end
    render status: 401, text: "Unauthorized"
  end

  def message
    if verify_request_signature
      return render text: "OK", status: 201
    end
    render status: 401, text: "Unauthorized"
  end

  private

  def verify_request_signature
    Chatbot::AuthorizeRequest.(request, ENV.fetch("FB_MESSENGER_APP_SECRET"))
  end
end
