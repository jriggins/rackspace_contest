require 'logger'
require_relative './rackspace_cloud_client'

class Application
  
  def initialize(args)
    self.logger = args.fetch(:logger)
    self.cloud_client = args.fetch(:cloud_client)
  end

  def run(message)
    logger.info("Initializing")
    file = cloud_client.create_cloud_file(message)
    output = cloud_client.get_text_from_url(file.public_url)
    logger.info("Output is #{output}")
    return output
  end

  def bootstrap_cloud
    connection = cloud_client.connect
    cloud_client.launch_compute_instance(connection)
    cloud_client.create_db
    cloud_client.cloud_files_copy
  end

private
  attr_accessor :cloud_client
  attr_accessor :logger
end


MESSAGE = "SCALING IN THE OPEN CLOUD WITH RACKSPACE"

begin
  logger = Logger.new(STDERR)
  output_message = Application.new(
    :cloud_client => RackspaceCloudClient.new(:logger => logger), 
    :logger => logger
  ).run(MESSAGE)
  puts output_message
rescue StandardError => e
  STDERR.puts("Error #{e}\n#{e.backtrace}")
  # We still print the message even if we got an error :)
  puts MESSAGE
end
