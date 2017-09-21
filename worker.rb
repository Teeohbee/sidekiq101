require 'sidekiq'
require 'sidekiq-scheduler'

Sidekiq.configure_client do |config|
  config.redis = { db: 1 }
end

Sidekiq.configure_server do |config|
  config.redis = { db: 1 }
end

class OurWorker
  include Sidekiq::Worker

  def perform(complexity)
    case complexity
    when "super_hard"
      sleep 20
      puts "Really took quite a bit of effort"
    when "hard"
      sleep 10
      puts "That was a bit of work"
    else
      sleep 1
      puts "That wasn't  a lot of effort"
    end
  end
end

class ErrorWorker
  include Sidekiq::Worker
  # sidekiq_options retry: 0

  def perform(errored)
    case errored
    when true
      puts "Charging credit card..."
      raise "An error occured"
    when false
      puts "Charging credit card..."
      puts "Payment was successful"
    else
      puts "You shouldn't be here"
    end
  end
end

class ScheduleWorker
  include Sidekiq::Worker

  JOBS = ['easy','hard','super_hard']

  def perform()
    JOBS.each do |job|
      OurWorker.perform_async(job)
    end
  end
end
