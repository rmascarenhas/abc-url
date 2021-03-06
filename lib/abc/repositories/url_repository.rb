class UrlRepository < Hanami::Repository

  def with_href(href)
    urls.where(href: href)
  end

  def count
    urls.count
  end

end
