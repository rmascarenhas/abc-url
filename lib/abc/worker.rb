require_relative "worker/ip_info"

module ABC

  # ABC::Worker
  #
  # This class is responsible for watching all Beanstalk tubes used in the
  # application, and registering the corresponding job processors to them.
  # It also knows how to enqueue a new job on a given tube.
  #
  # Usage
  #
  #   worker = ABC::Worker.new
  #   worker.enqueue("some-tube", args)
  #
  #   worker.start! # => loop processing jobs
  class Worker
    class << self
      # the Beanstalk client being used in the running application. This must be
      # set during application boot. See initializer file.
      attr_accessor :client
    end

    # The list of jobs currently being processed in the application.
    # Maps tube-name => processor instance.
    #
    # Processors need to respond to the +process+ method, receiving a Hash of
    # arguments given when the job was enqueued.
    JOBS = {
      ENV["BEANSTALK_IPINFO_TUBE"] => IpInfo.new
    }

    # if this exception is raised during the processing of a certain job,
    # Beanstalk will retry the job. Processor instances, therefore, are
    # expected to raise +ABC::Worker::RetryableError+ if recoverable or
    # temporary issues are detected.
    class RetryableError < RuntimeError
    end

    def start!
      JOBS.each do |tube, processor|
        client.jobs.register(tube, retry_on: [RetryableError]) do |job|
          processor.process(job.body)
        end
      end

      client.jobs.process!
    end

    def enqueue(tube, params)
      client.tubes[tube].put(params)
    end

    private

    def client
      self.class.client
    end

  end
end
