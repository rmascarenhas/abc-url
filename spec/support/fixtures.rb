module Support

  module Fixtures
    def read_fixture(path)
      path = Hanami.root.join("spec", "fixtures", path).to_s
      File.read(path)
    end
  end

end
