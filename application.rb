class Application
  
  def initialize(cloud_client)
    self.cloud_client = cloud_client
  end

  def bootstrap_cloud
    cloud_client.launch_compute_instance
    cloud_client.create_db
    cloud_client.cloud_files_copy
  end

  LAUNCH_SERVER_COMMAND = <<EOF
sudo bash -c "apt-get update && apt-get -y install ruby && apt-get install -y 
EOF

private
  attr_accessor :cloud_client

end
