module Chatbot
  class FacebookUser
    attr_reader :first_name
    attr_reader :last_name
    attr_reader :locale
    attr_reader :timezone
    attr_reader :profile_pic
    attr_reader :gender
    attr_reader :is_payment_enabled
    attr_reader :last_ad_referal

    def initialize(attrs)
      attrs.each do |k,v|
        instance_variable_set("@#{k}", v)
      end
    end

    def w2h_locale
      Locale.from_facebook(locale).locale
    end
  end
end
