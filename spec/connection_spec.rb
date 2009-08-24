require File.dirname(__FILE__) + "/../lib/healthvault"
include HealthVault

describe Connection do
  before(:each) do
    app = Application.default
    @connection = app.create_connection
  end

  it "should authenticate the application" do
    @connection.authenticated?.should == false
    @connection.authenticate
    @connection.authenticated?.should == true
  end
  
end

