require "hanami/helpers"
require "hanami/assets"

module Api
  VERSION = "1.0"

  class Application < Hanami::Application
    configure do
      root __dir__

      load_paths << [
        "controllers",
        "transactions"
      ]

      routes "config/routes"

      # an API does not need cookies or session management
      cookies  false
      sessions false

      default_request_format  :json
      default_response_format :json
      body_parsers            :json

      security.x_xss_protection "1; mode=block"
    end

    configure :development do
      handle_exceptions false
    end

    configure :test do
      handle_exceptions false

      logger.level :error
    end

    configure :production do
      logger.level  :info
      logger.format :json
    end
  end
end
