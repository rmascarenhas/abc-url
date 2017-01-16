module Web::Views::Url

  # The +Show+ page only renders the HTML template located at
  # +app/templates/url/show.thml.erb+
  class Show
    include Web::View

    def short_link
      [ENV["ABC_URL"], "/", code].join
    end
  end

end
