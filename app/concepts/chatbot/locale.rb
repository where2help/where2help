module Chatbot
  class Locale
    Data = Struct.new(:locale, :facebook_locale)

    LOCALES = {
      "en" => Data.new("en", "en_US"),
      "de" => Data.new("de", "de_DE")
    }

    def self.locales; LOCALES.values; end

    def self.from_facebook(fb_locale)
      LOCALES.values.find { |l| l.facebook_locale == fb_locale } || default
    end

    def self.from_w2h(locale)
      LOCALES[locale] || default
    end

    def self.default; LOCALES["en"]; end

    def self.default_for_menu
      Data.new("en", "default")
    end
  end
end
