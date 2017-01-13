require "spec_helper"

RSpec.describe UrlRepository do

  describe "#with_href" do
    let(:href) { "https://www.example.org" }

    it "returns an empty collection in case there are no records in the database" do
      expect(subject.with_href(href).to_a).to eq []
    end

    it "returns an empty collection if the requested URL does not exist" do
      subject.create(Url.new(href: "http://www.example.org")) # no HTTPS
      subject.create(Url.new(href: "https://google.com"))

      expect(subject.with_href(href).to_a).to eq []
    end

    it "returns the requested URL when it exists" do
      subject.create(Url.new(href: "https://www.example.org"))

      expect(subject.with_href(href).first.href).to eq "https://www.example.org"
    end
  end

end
