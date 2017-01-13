class UrlRepository < Hanami::Repository

  def with_href(href)
    urls.where(href: href)
  end

end
