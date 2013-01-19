require 'fog'

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
