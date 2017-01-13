module Web::Controllers::Url

  # Web::Controllers::Url::Show
  #
  # The controller for the root of the URL shortening app. No parameters are
  # expected in this endpoint.
  class Show
    include Web::Action

    attr_reader :repository

    expose :url

    params do
      required(:id).filled(:int?)
    end

    def initialize(repository: UrlRepository.new)
      @repository = repository
    end

    def call(params)
      if params.valid?
        @url = repository.find(params[:id])
      else
        self.status = 404
        self.body   = "Not Found"
      end
    end
  end

end
