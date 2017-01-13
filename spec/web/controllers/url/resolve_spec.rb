require "spec_helper"

RSpec.describe Web::Controllers::Url::Resolve do
  let(:repository) { UrlRepository.new }
  let(:url) { repository.create(Url.new(href: "https://www.example.org")) }
  let(:params) {
    { code: ABC::Url.encode(url.id) }
  }

  def call(params)
    status, headers, body = subject.call(params)
    [status, headers, body.first]
  end

  it "returns 404 in case the code provided does not match any known URL" do
    # make sure the key used for encoding is from an ID that does not exist in
    # the database
    code = ABC::Url.encode(url.id + 1)
    params[:code] = code

    status, headers, body = call(params)
    expect(status).to eq 404
    expect(body).to eq "Not Found"
  end

  it "redirects to the full URL when the code matches an existing URL" do
    status, headers, body = call(params)

    expect(status).to eq 301
    expect(headers["Location"]).to eq "https://www.example.org"
  end
end
