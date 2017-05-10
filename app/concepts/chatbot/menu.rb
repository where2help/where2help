module Chatbot
  class Menu
    def to_json
      all_locales = Locale.locales << Locale.default_for_menu
      {
        persistent_menu: all_locales.map { |l| locale_menu(l.facebook_locale, l.locale) }
      }
    end

    private

    def website_url
      Rails.application.routes.url_helpers.root_url
    end

    def locale_menu(fb_locale, locale)
      {
        locale: fb_locale,
        composer_input_disabled: true,
        call_to_actions: menu_buttons(locale)
      }
    end

    def menu_buttons(locale)
      [
        help_button(locale),
        website_button(locale)
      ]
    end

    def help_button(locale)
      {
        title: I18n.t("chatbot.menu.help", locale: locale),
        type: "postback",
        payload: Postbacks::HELP_PAYLOAD
      }
    end

    def website_button(locale)
      {
        title: I18n.t("chatbot.menu.website", locale: locale),
        type: "web_url",
        url: website_url
      }
    end
  end
end
