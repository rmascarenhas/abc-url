module ABC

  # ABC::IpInfoClient
  #
  # This is a simple client to the ipinfo.io API. This service allows callers to
  # easily retrieve information about a certain IP address (specially its
  # location.)
  #
  # This client implements only IP lookups using the /geo API, which does not
  # include information about organization and connection provider, since these
  # are irrelevant for this application.
  class IpInfoClient

    # ABC::IpInforClient::Geo
    #
    # Contains the parsed data from the response of the ipinfo.io service.
    Geo = Struct.new(:ip, :coordinates, :city, :region, :country) do
      def lat
        coordinates.split(",").first.to_f
      end

      def lng
        coordinates.split(",").last.to_f
      end
    end

    API_URL = "https://ipinfo.io"

    attr_reader :ip, :http

    def initialize(ip, connection: default_connection)
      @ip   = ip
      @http = connection
    end

    def geo
      endpoint = ["/", ip, "/geo"].join
      response = http.get(endpoint)

      data = JSON.parse(response.body)
      Geo.new(
        ip,
        data["loc"],
        data["city"],
        data["region"],
        data["country"]
      )
    end

    private

    def default_connection
      Faraday.new(url: API_URL)
    end

  end

end
