require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Apiwoods
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.i18n.available_locales = ['zh-CN', 'en', 'zh-TW']
    config.i18n.fallbacks = true

    config.autoload_paths += [
      Rails.root.join('lib')
    ]

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end

    config.active_job.queue_name_prefix = Rails.env
    config.active_job.queue_name_delimiter = '.'
    config.active_job.queue_adapter = :sidekiq
    config.middleware.use Rack::Attack

    config.to_prepare do
      Devise::SessionsController.layout "devise"
      Devise::RegistrationsController.layout "devise"
      Devise::ConfirmationsController.layout "devise"
      Devise::UnlocksController.layout "devise"            
      Devise::PasswordsController.layout "devise"        
    end

    config.webpack = {
      asset_manifest: {}
    }
  end
  
end
