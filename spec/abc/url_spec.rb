require "spec_helper"

RSpec.describe ABC::Url do
  let(:alphabet) { "abc123" } # base=6

  describe ".encode" do
    def encode(key)
      described_class.encode(key, alphabet: alphabet)
    end

    it "is able to shorten keys shorter than the alphabet base" do
      key = 2
      expect(encode(key)).to eq "c" # alphabet[2]
    end

    it "shortens arbitrarily large keys" do
      key = 5*(6**3) + 2*(6**2) + 3*(6**1) + 0*(6**0)

      # alphabet[5]+alphabet[2]+alphabet[3]+alphabet[0]
      expect(encode(key)).to eq "3c1a"
    end
  end
end
