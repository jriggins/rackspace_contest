require 'spec_helper'
require_relative "../application"

describe Application do
  context "#bootstrap_cloud" do
    let(:cloud_client) { double() }
    subject { Application.new(cloud_client) }

    it "should launch a server" do
      cloud_client.should_receive(:launch_compute_instance)
      cloud_client.should_receive(:create_db)
      cloud_client.should_receive(:cloud_files_copy)

      subject.bootstrap_cloud
    end
    #it "should create a Rackspace Cloud DB" do 
      #cloud_client = double() 
      #cloud_client.stub(:create_db)
      #cloud_client.should_receive(:create_db)

      #Application.new(cloud_client).bootstrap_cloud
    #end
      #it "should copy the message from Rackspace Cloud Files into the DB"
  end

  it "should tear down the Rackspace server"
  it "should tear down the Rackspace Cloud DB"
  it "should remove the message from Rackspace Cloud Files"
end
