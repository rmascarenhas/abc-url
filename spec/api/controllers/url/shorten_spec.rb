require "spec_helper"

RSpec.describe Api::Controllers::Url::Shorten do
  let(:params) {
    { url: "https://www.example.org" }
  }
  let(:repository) { UrlRepository.new }

  def call(params)
    status, headers, body = subject.call(params)

    # the +body+ parameter is an Array of String objects (iterable to allow
    # streaming, not used in this API.) For convenience, parse the first
    # element of the array, which will be the entire response body, from the
    # JSON format.
    [status, headers, JSON.parse(body.first)]
  end

  it "is not successful if the +url+ parameter is not provided" do
    status, headers, body = call({})

    expect(status).to eq 422
    expect(body).to eq({
      "status" => "error",
      "errors" => { "url" => "Not a valid URL" }
    })
  end

  [nil, "", "invalid-url", "  \t  "].each do |invalid_url|
    it "is not successful if the +url+ parameter given is not a valid URL (e.g., #{invalid_url.inspect})" do
      params[:url] = invalid_url
      status, headers, body = call({})

      expect(status).to eq 422
      expect(body).to eq({
        "status" => "error",
        "errors" => { "url" => "Not a valid URL" }
      })
    end
  end

  it "creates an URL record when the URL given does not exist" do
    status, headers, body = call(params)

    expect(status).to eq 201
    expect(body["status"]).to eq "ok"
    expect(body["id"]).to be > 0
  end

  it "returns the ID of an existing URL record if it exists" do
    url = repository.create(Url.new(href: "https://www.example.org"))
    status, headers, body = call(params)

    expect(status).to eq 201
    expect(body).to eq({
      "status" => "ok",
      "id"     => url.id
    })
  end
end
