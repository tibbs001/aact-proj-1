require_relative 'boot'
require 'csv'
require 'zip'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AactProj
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    AACT_DB_SUPER_USERNAME = ENV['AACT_DB_SUPER_USERNAME'] || 'aact'   # Name of postgres superuser that has permission to create a database.
    WIKI_DB_SUPER_USERNAME = ENV['WIKI_DB_SUPER_USERNAME'] || 'wiki'
    AACT_STATIC_FILE_DIR   = ENV['AACT_STATIC_FILE_DIR'] || '~/aact-files'  # directory containing AACT static files such as the downloadable db snapshots

    APPLICATION_HOST          = 'localhost'
    if Rails.env != 'test'
      AACT_PUBLIC_HOSTNAME      =  ENV['AACT_PUBLIC_HOSTNAME'] || 'localhost'#Server on which the publicly accessible database resides
      AACT_ADMIN_DATABASE_NAME  =  ENV['AACT_ADMIN_DATABASE_NAME'] || 'aact_admin' # Name of database used to support the AACT website
      AACT_PUBLIC_DATABASE_NAME =  ENV['AACT_PUBLIC_DATABASE_NAME'] || 'aact'  # Name of database available to the public
      AACT_ALT_PUBLIC_DATABASE_NAME = ENV['AACT_ALT_PUBLIC_DATABASE_NAME'] || 'aact_alt' # Name of alternate database available to the public
    else
      AACT_PUBLIC_HOSTNAME      = 'localhost'
      AACT_ADMIN_DATABASE_NAME  = 'aact_admin_test'
      AACT_PUBLIC_DATABASE_NAME = 'aact_test'
      AACT_ALT_PUBLIC_DATABASE_NAME = 'aact_alt_test'
    end
    AACT_ADMIN_DATABASE_URL      = "postgres://#{AACT_DB_SUPER_USERNAME}@#{APPLICATION_HOST}:5432/#{AACT_ADMIN_DATABASE_NAME}"
    AACT_PUBLIC_DATABASE_URL     = "postgres://#{AACT_DB_SUPER_USERNAME}@#{AACT_PUBLIC_HOSTNAME}:5432/#{AACT_PUBLIC_DATABASE_NAME}"
    AACT_ALT_PUBLIC_DATABASE_URL = "postgres://#{AACT_DB_SUPER_USERNAME}@#{AACT_PUBLIC_HOSTNAME}:5432/#{AACT_ALT_PUBLIC_DATABASE_NAME}"

    # If you deploy to a server, you need the following env variables defined for capistrano:
    # AACT_DEPLOY_TO
    AACT_PROD_REPO_URL="git@github.com:tibbs001/aact-proj-1.git"
    AACT_PROD_SERVER="45.55.54.109"
    AACT_DEV_REPO_URL="git@github.com:tibbs001/aact-proj-1.git"
    AACT_DEV_SERVER="45.55.54.109"
    AACT_SERVER_USERNAME="tibbs001"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
