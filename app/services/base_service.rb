class BaseService
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::PolymorphicRoutes

  def self.call(*args)
    new(*args).call
  end

  def call
    raise NotImplementedError, "call method not implemented for #{self.class}"
  end

  private

  def host
    @host ||= Rails.application.config.action_mailer.default_url_options[:host]
  end
end
