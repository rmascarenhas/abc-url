require "spec_helper"

RSpec.describe ABC::IpInfoClient do
  include Support::Fixtures

  let(:ip) { "8.8.8.8" }
  let(:stubbed_url) { "/8.8.8.8/geo" }
  let(:connection) {
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get(stubbed_url) { |env| stubbed_response }
      end
    end
  }

  subject { described_class.new(ip, connection: connection) }

  context "successful operation of the ipinfo service" do
    let(:stubbed_response) { [200, {}, read_fixture("ipinfo/success.json")] }

    it "returns the parsed response from the service" do
      geo = subject.geo

      expect(geo).to be_a ABC::IpInfoClient::Geo
      expect(geo.ip).to eq "8.8.8.8"
      expect(geo.coordinates).to eq "37.385999999999996,-122.0838"
      expect(geo.lat).to eq 37.385999999999996
      expect(geo.lng).to eq -122.0838
      expect(geo.city).to eq "Mountain View"
      expect(geo.region).to eq "California"
      expect(geo.country).to eq "US"
    end
  end

  context "ipinfo returns an unsuccessful status" do
    let(:stubbed_response) { [500, {}, "Internal Server Error"] }

    it "retries by raising a retryable error" do
      expect {
        subject.geo
      }.to raise_exception(ABC::Worker::RetryableError)
    end
  end

  context "ipinfo cannot be reached (network-level error)" do
    let(:stubbed_response) { raise Faraday::ConnectionFailed.new({}) }

    it "retries by raising a retryable error" do
      expect {
        subject.geo
      }.to raise_exception(ABC::Worker::RetryableError)
    end
  end
end
