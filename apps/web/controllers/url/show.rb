module Web::Controllers::Url

  # Web::Controllers::Url::Show
  #
  # This is the controller for the page where a shortened link stats are displayed.
  # The shortened URL as well as information on the latest clicks are shown
  # in this page.
  class Show
    include Web::Action

    attr_reader :urls, :clicks

    expose :url, :clicks, :code

    params do
      required(:id).filled(:int?)
    end

    def call(params)
      @url = params.valid? && urls_repo.find(params[:id])

      if @url
        @clicks = clicks_repo.for_url(url)
        @code   = ABC::Url.encode(url.id)
      else
        self.status = 404
        self.body   = "Not Found"
      end
    end

    private

    def urls_repo
      @_urls_repo ||= UrlRepository.new
    end

    def clicks_repo
      @_clicks_repo ||= ClickRepository.new
    end
  end

end
