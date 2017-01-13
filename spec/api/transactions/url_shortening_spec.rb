require "spec_helper"

RSpec.describe Api::Transactions::UrlShortening do
  let(:params) {
    Hanami::Action::BaseParams.new("url" => "https://www.example.org")
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
      expect {
        subject.run
      }.to change { repository.count }.by(1)
    end
  end
end
