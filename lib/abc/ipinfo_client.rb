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

    # This error indicates that a failure happened when trying to invoke the
    # ipinfo.io service in order to get IP information.
    class NetworkFailure < RuntimeError
    end

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
      response = fetch_ipinfo

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

    # this makes the actual HTTP call to the ipinfo.io service. If the response
    # is not successful (out of the 2XX HTTP status) or if there is an error
    # at the network level (service is unreachable, the connection times out,
    # etc.), an exception is raised (+ABC::IpInfoClient::NetworkError+).
    def fetch_ipinfo
      endpoint = ["/", ip, "/geo"].join

      http.get(endpoint).tap do |response|
        failure! unless response.success?
      end

    rescue Faraday::Error
      failure!
    end

    def failure!
      raise NetworkFailure
    end

    def default_connection
      Faraday.new(url: API_URL)
    end

  end

end
