require 'fog'
require 'net/http'
require 'logger'

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

class RackspaceCloudClient
  attr_accessor :api_key
  attr_accessor :api_username
  attr_accessor :connection
  attr_accessor :server
  attr_accessor :file
  attr_accessor :logger

  def initialize(args={})
    self.logger = args.fetch(:logger)
  end

  def connect
    connection ||= Fog::Compute.new(:provider => 'Rackspace', :version => :v2)
  end

  def launch_compute_instance(connection)
    server ||= connection.servers.bootstrap(
      :name => 'Contest Server', 
      :image_id => "5cebb13a-f783-4f8c-8058-c4182c724ccd", 
      :flavor_id => 2
    )
  end

  def install_dependencies(server)
    server.ssh("apt-get update && apt-get install -y mysql-client")
  end

  def create_db(connection)
  end

  def create_cloud_file(text)
    # Law of Demeter, Schmeter! :)
    file ||= Fog::Storage.new(:provider => "Rackspace").directories.create(
      :key => "rackspace-contest", :public => true).files.create(
        :key => 'message', :content_type => "text/plain", :body => text)
    file.tap do |f|
      logger.info { "Cloud File URL: #{f.public_url}" }
    end
  end

  def get_text_from_url(url)
    Excon::get(url).body
  end

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
