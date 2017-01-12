module Api::Controllers::Root

  # This is the root of the ABC API. It returns application information,
  # and can be used as a health check endpoint if deployed behind a load balancer
  class Index
    include Api::Action

    def call(params)
      self.body = {
        status:  "ok",
        time:    Time.now,
        version: Api::VERSION
      }.to_json
    end

  end
end
