# workaround, to set default locale to :de for ALL spec
class ActionView::TestCase::TestController
  def default_url_options(options = {})
    { locale: I18n.default_locale }
  end
end

class ActionDispatch::Routing::RouteSet
  def default_url_options(options = {})
    { locale: I18n.default_locale }
  end
end
