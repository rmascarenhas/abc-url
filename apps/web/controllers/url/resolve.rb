module Web::Controllers::Url

  # Web::Controllers::Url::Resolve
  #
  # This is the endpoint to be used for resolving arbitrary shortened URLs
  # back to their expanded version.
  class Resolve
    include Web::Action

    attr_reader :repository

    params do
      required(:code).filled(:str?)
    end

    def initialize(repository: UrlRepository.new)
      @repository = repository
    end

    def call(params)
      key = ABC::Url.decode(params[:code])
      url = repository.find(key)

      # if there is an URL for the requested code, redirect it with a clean
      # 301 (Moved Permanently.) This might cause the browser to cache the result
      # and subsequent clicks from the same user will not hit the URL shortening
      # app.
      #
      # However, that is a best practice since the content of the destination
      # URL is attributed to the expanded URL, which is good for SEO reasons.
      if url
        enqueue_click_analysis(url)
        redirect_to url.href, status: 301
      else
        self.status = 404
        self.body   = "Not Found"
      end
    end

    private

    # enqueues a new job for the Beanstalk job processor. This includes the caller's
    # request information. With the provided IP, the processor can query location
    # information, and save that to the +clicks+ table.
    def enqueue_click_analysis(url)
      worker = ABC::Worker.new
      args   = {
        url_id:     url.id,
        ip:         request.ip,
        user_agent: request.user_agent,
        referer:    request.referer
      }

      worker.enqueue(ENV["BEANSTALK_IPINFO_TUBE"], args)
    end

  end

end
