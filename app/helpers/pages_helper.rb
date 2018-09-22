module PagesHelper
  def locale_path_for(locale)
    return root_path(locale: locale) unless request.get?
    url_for(locale: locale, action: request.parameters['action'])
  end
end
