# serialize job arguments to and from the JSON format.
Beaneater.configure do |config|
  config.job_parser     = ->(body) { JSON.parse(body) }
  config.job_serializer = ->(data) { data.to_json }
end

ABC::Worker.client = Beaneater.new(ENV["BEANSTALK_URL"])
