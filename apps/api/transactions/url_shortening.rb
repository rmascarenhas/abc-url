module Api::Transactions

  # Api::Transactions::UrlShortening
  #
  # This class implements the flow to be run when the API call to perform an
  # URL shortening operation is invoked.
  #
  # The app currently does not support multiple users: therefore, every URL
  # is assumed to be from the same user. If there already exists a database
  # record for the requested URL, the code for it is returned. Otherwise, a
  # new record is created, and the code for the new identifier is returned.
  #
  # Note that this class is called when the given +params+ are already validated.
  # Therefore, this class does not need to perform checks such as whether the
  # +url+ parameter is present or whether it is valid.
  class UrlShortening
    attr_reader :url, :repository

    def initialize(params)
      @url = params[:url]
      @repository = UrlRepository.new
    end

    def run
      existing_record || create_new_url
    end

    private

    def existing_record
      repository.with_href(normalized_url).first
    end

    def create_new_url
      entity = Url.new(href: normalized_url)
      repository.create(entity)
    end

    # if the incoming URL does is not prefixed with either +http://+ or +https://+,
    # assume HTTP and add it to the URL. This way, if subsequent shortening calls
    # to the same URL are made in the future, the API will not create two different
    # links.
    def normalized_url
      if url =~ %r{^https?://}
        url
      else
        ["http://", url].join
      end
    end
  end

end
