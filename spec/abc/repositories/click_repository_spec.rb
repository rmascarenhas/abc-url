require "spec_helper"

RSpec.describe ClickRepository do

  describe "#for_url" do
    let(:urls) { UrlRepository.new }
    let(:url) { urls.create(Url.new(href: "https://www.example.org")) }

    it "returns an empty collection in case there are no records in the database" do
      expect(subject.for_url(url).to_a).to eq []
    end

    it "returns an empty collection if there are no clicks for the requested URL" do
      new_url = urls.create(Url.new(href: "https://www.google.com"))
      click = subject.create(url_id: new_url.id, ip: "8.8.8.8", user_agent: "Mozilla", country: "US")

      expect(subject.for_url(url).to_a).to eq []
    end

    it "returns the clicks for the requested URL when they are given" do
      click = subject.create(url_id: url.id, ip: "8.8.8.8", user_agent: "Mozilla", country: "US")
      expect(subject.for_url(url).to_a.map(&:id)).to eq [click.id]
    end
  end

end
