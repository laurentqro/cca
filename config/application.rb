require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Cca
  class Application < Rails::Application
    config.load_defaults 5.1
    config.i18n.default_locale = :fr
    config.action_mailer.default_url_options = { host: ENV['HOST'] }
    config.paths.add "app/serializers", eager_load: true

    config.generators do |g|
      g.test_framework  false
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
      g.channel         assets: false
    end
  end
end
