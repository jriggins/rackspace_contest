require 'spec_helper'
require_relative "../application"

describe Application do
  it "should launch the Rackspace server"
  it "should create a Rackspace Cloud DB"
  it "should copy the message from Rackspace Cloud Files into the DB"
  it "should tear down the Rackspace server"
  it "should tear down the Rackspace Cloud DB"
  it "should remove the message from Rackspace Cloud Files"
end
