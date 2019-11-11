require_relative 'boot'
require 'csv'
require 'zip'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
#Bundler.require(*Rails.groups)

module AACT
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.active_record.schema_format = :sql
    config.i18n.fallbacks = [I18n.default_locale]

    AACT_DB_SUPER_USERNAME = ENV['AACT_DB_SUPER_USERNAME'] || 'ctti'
    AACT_STATIC_FILE_DIR   = ENV['AACT_STATIC_FILE_DIR'] || '/aact-files'  # directory containing AACT static files such as log files

    if Rails.env == 'test'
      APPLICATION_HOST          = 'localhost'
      AACT_PUBLIC_HOSTNAME      = 'localhost'
      AACT_BACK_DATABASE_NAME   = 'aact_back_test'
      AACT_PUBLIC_DATABASE_NAME = 'aact_test'
      AACT_PROJ_DATABASE_NAME   = 'aact_proj_test'
    else
      APPLICATION_HOST          = ENV['APPLICATION_HOST'] || 'localhost'
      AACT_PUBLIC_HOSTNAME      = ENV['AACT_PUBLIC_HOSTNAME'] || 'localhost'
      AACT_BACK_DATABASE_NAME   = ENV['AACT_BACK_DATABASE_NAME'] || 'aact_back'
      AACT_PUBLIC_DATABASE_NAME = ENV['AACT_PUBLIC_DATABASE_NAME'] || 'aact'
      AACT_PROJ_DATABASE_NAME   = ENV['AACT_PROJ_DATABASE_NAME'] || 'aact_proj'
    end

    AACT_PROJ_DATABASE_URL   = "postgres://#{AACT_DB_SUPER_USERNAME}@#{AACT_PUBLIC_HOSTNAME}:5432/#{AACT_PROJ_DATABASE_NAME}"
    AACT_PUBLIC_DATABASE_URL = "postgres://#{AACT_DB_SUPER_USERNAME}@#{AACT_PUBLIC_HOSTNAME}:5432/#{AACT_PUBLIC_DATABASE_NAME}"
    AACT_ALT_PUBLIC_DATABASE_URL = "postgres://#{AACT_DB_SUPER_USERNAME}@#{AACT_PUBLIC_HOSTNAME}:5432/#{AACT_PUBLIC_DATABASE_NAME}_alt"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
