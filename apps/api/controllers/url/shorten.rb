module Api::Controllers::Url

  # This is the controller for the API endpoint to perform the shortening
  # of URLs. What this does is to save the URL in the database if the parameter
  # given is valid (that is, present and a valid URL.)
  #
  # If the URL is saved in the database, the table identifier can then be used
  # later as the key to the encoding of a shortened URL (see +ABC::Url+).
  class Shorten
    include Api::Action

    params do
      required(:url).filled(:str?, format?: URI.regexp)
    end

    def call(params)
      unless params.valid?
        return error_response
      end

      transaction = Api::Transactions::UrlShortening.new(params)
      url = transaction.run

      self.status = 201
      self.body = {
        status: "ok",
        id:     url.id
      }.to_json
    end

    private

    def error_response
      self.status = 422
      self.body   = {
        status: "error",
        errors: { url: "Not a valid URL" }
      }.to_json
    end
  end

end
