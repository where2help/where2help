require "openssl"
require "rack"

class Chatbot::AuthorizeRequest
  def call(request, app_secret)
    payload   = request.body.read
    signature = get_signature(payload, app_secret)
    signature_valid?(signature, request.env)
  end

  def get_signature(payload, app_secret)
    digest = OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new("sha1"),
      app_secret,
      payload
    )
    "sha1=" + digest
  end

  def signature_valid?(signature, env)
    Rack::Utils.secure_compare(signature, env["HTTP_X_HUB_SIGNATURE"])
  end
end
