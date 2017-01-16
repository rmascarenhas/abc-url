class ABC::Worker

  # ABC::Worker::IpInfo
  #
  # This job processes enqueued messages on the ipinfo beanstalk tube.
  # It receives as argument a Hash (parsed from JSON) of request data,
  # invokes the ipinfo.io service to get location information of the
  # requester, and finally saves the data back on the databse (+clicks+ table).
  #
  # If there is a network error when trying to get location information
  # on the ipinfo.io service, this class raises a +ABC::Worker::RetryableError+
  # which causes the beanstalk client to re-process the job later.
  class IpInfo

    def process(args, client: nil)
      client ||= ABC::IpInfoClient.new(args[:ip])
      geo = client.geo

      click = Click.new(
        url_id:     args[:url_id],
        ip:         args[:ip],
        user_agent: args[:user_agent],
        referer:    args[:referer],
        lat:        geo.lat,
        lng:        geo.lng,
        city:       geo.city,
        region:     geo.region,
        country:    geo.country
      )

      ClickRepository.new.create(click)

    rescue ABC::IpInfoClient::NetworkFailure
      raise ABC::Worker::RetryableError
    end

  end
end
