class ClickRepository < Hanami::Repository
  def count
    clicks.count
  end
end
