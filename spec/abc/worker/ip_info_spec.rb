require "spec_helper"

RSpec.describe ABC::Worker::IpInfo do
  let(:url) { UrlRepository.new.create(Url.new(href: "https://www.example.org")) }
  let(:args) {
    {
      "url_id"     => url.id,
      "ip"         => "1.2.3.4",
      "user_agent" => "Mozilla",
      "referer"    =>"www.google.com"
    }
  }
  let(:client) { ABC::IpInfoClient.new("1.2.3.4") }
  let(:clicks) { ClickRepository.new }

  describe "#process" do
    it "retries the job if there is a network error when invoking the ipinfo service" do
      allow(client).to receive(:geo) { raise ABC::IpInfoClient::NetworkFailure }
      expect {
        expect {
          subject.process(args, client: client)
        }.not_to change { clicks.count }
      }.to raise_exception(ABC::Worker::RetryableError)
    end

    it "creates a click with the data retrieved from the ipinfo.io service" do
      geo = ABC::IpInfoClient::Geo.new(
        "1.2.3.4", "1.23,3.21", "Mountain View", "California", "US"
      )
      allow(client).to receive(:geo) { geo }

      expect {
        subject.process(args, client: client)
      }.to change { clicks.count }.by(1)

      click = clicks.last
      expect(click.url_id).to eq url.id
      expect(click.ip).to eq "1.2.3.4"
      expect(click.user_agent).to eq "Mozilla"
      expect(click.referer).to eq "www.google.com"
      expect(click.lat).to eq 1.23
      expect(click.lng).to eq 3.21
      expect(click.city).to eq "Mountain View"
      expect(click.region).to eq "California"
      expect(click.country).to eq "US"
    end
  end
end
