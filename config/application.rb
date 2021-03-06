require_relative 'boot'

require 'rails/all'
require 'rails_autolink'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CancerSns
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.i18n.default_locale = :ja

    config.active_record.time_zone_aware_types = [:datetime, :time]

    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    config.generators do |g|
  	  g.helper false
  	  g.assets false
  	end

    config.autoload_paths << Rails.root.join('policies')
    config.autoload_paths << Rails.root.join('view_objects')

    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
