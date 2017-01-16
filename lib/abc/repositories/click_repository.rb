class ClickRepository < Hanami::Repository
  def count
    clicks.count
  end

  def for_url(url)
    clicks.where(url_id: url.id)
  end
end
