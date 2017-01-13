module ABC

  # ABC::Url
  #
  # This class is the external interface tha callers can use in order to generate
  # shortened URLs.
  #
  # Usage
  #
  #   key = 3298 # numeric key used to generate shortened URLs
  #   ABC::Url.encode(key) # => "cb2a"
  #
  #   ABC::Url.decode("cb2a") # => 3298
  #
  # Typicall, the +key+ parameter passed to the +ABC::Url.encode+ method is a
  # numeric sequence, potentially from a database.
  class Url
    ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_"

    # alphabet: the alphabet of characters to be used when generating the
    # code for the shortened URL.
    def self.encode(key, alphabet: ALPHABET)
      UrlEncoder.new(key, alphabet).encode
    end
  end

  # ABC::Url::UrlEncode
  #
  # This class knows how to transform a numeric key into a string representation
  # of a given alphabet. What it does under the hood is basically to transform
  # a number in decimal base (the key) into another number in a different base
  # (base = size of the given alphabet.)
  #
  # Each "digit" in the target base is taken as the element in the corresponding
  # position in the collection of characters that compose the alphabet.
  class UrlEncoder
    attr_reader :key, :alphabet

    def initialize(key, alphabet)
      @key      = key
      @alphabet = alphabet
    end

    def encode
      base  = alphabet.size
      chars = ""
      # use a local variable pointing to the @key instance variable in order not
      # to mess with Ruby's variable scope in inside the +while+ loop below
      key   = @key

      while key > 0
        chars << alphabet[key % base]
        key /= base
      end

      chars.reverse
    end
  end

end
