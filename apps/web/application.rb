require "hanami/helpers"
require "hanami/assets"

module Web
  class Application < Hanami::Application
    configure do
      root __dir__

      load_paths << [
        "controllers",
        "views"
      ]

      routes "config/routes"

      # we do not need sessions for now
      sessions false

      default_request_format :html
      default_response_format :html

      layout :application
      templates "templates"

      assets do
        javascript_compressor :builtin
        stylesheet_compressor :builtin

        sources << [
          "assets"
        ]
      end

      security.x_frame_options        "DENY"
      security.x_content_type_options "nosniff"
      security.x_xss_protection       "1; mode=block"

      view.prepare do
        include Hanami::Helpers
        include Web::Assets::Helpers
      end
    end

    configure :development do
      handle_exceptions false
    end

    configure :test do
      handle_exceptions false
      logger.level      :error
    end

    configure :production do
      logger.level  :info
      logger.format :json

      assets do
        compile     false
        fingerprint true

        subresource_integrity :sha256
      end
    end
  end
end
