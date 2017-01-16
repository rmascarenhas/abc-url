require "spec_helper"

RSpec.describe Api::Transactions::UrlShortening do
  let(:raw_params) {
    { "url" => "https://www.example.org" }
  }
  let(:params) {
    Hanami::Action::BaseParams.new(raw_params)
  }
  let(:repository) { UrlRepository.new }

  subject { described_class.new(params) }

  describe "#run" do
    it "uses an existing record if it exists" do
      url = repository.create(Url.new(href: "https://www.example.org"))

      expect {
        record = subject.run
        expect(subject.run.id).to eq url.id
      }.not_to change { repository.count }
    end

    it "creates a new URL and uses that to generate a URL code if no record exists" do
      url = nil

      expect {
        url = subject.run
      }.to change { repository.count }.by(1)

      expect(url.href).to eq "https://www.example.org"
    end

    it "prepends `http://` if not given" do
      raw_params["url"] = "www.example.org"

      url = subject.run
      expect(url.href).to eq "http://www.example.org"
    end

    it "returns an existing record if the `http://` prefix is missing" do
      existing = repository.create(Url.new(href: "http://www.example.org"))
      raw_params["url"] = "www.example.org"

      url = subject.run
      expect(url.id).to eq existing.id
    end
  end
end
