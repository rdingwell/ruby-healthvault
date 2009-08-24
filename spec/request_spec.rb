require File.dirname(__FILE__) + "/../lib/healthvault"
include HealthVault

describe Request do
  before(:each) do
    app = Application.default
    @connection = app.create_connection
  end

  it "should get service definitions without authenticating" do
    request = Request.create("GetServiceDefinition", @connection)
    result = request.send
    result.info.should be_an_instance_of(HealthVault::WCData::Methods::Response::GetServiceDefinition::Info)
    result.info.platform.should be_an_instance_of(HealthVault::WCData::Methods::Response::GetServiceDefinition::Platform)
    result.info.shell.should be_an_instance_of(HealthVault::WCData::Methods::Response::GetServiceDefinition::Shell)
    result.info.sdk_assembly.should_not be_empty
    result.info.sdk_assembly.each {|a| a.should be_an_instance_of(HealthVault::WCData::Methods::Response::GetServiceDefinition::SDKAssembly)}
    result.info.xml_method.should_not be_empty
    result.info.xml_method.each {|m| m.should be_an_instance_of(HealthVault::WCData::Methods::Response::GetServiceDefinition::XmlMethod)}
    result.info.common_schema.should_not be_empty
    result.info.common_schema.each {|c| c.should be_an_instance_of(String)}
  end
  
  it "should get thing types without authenticating" do
    request = Request.create("GetThingType", @connection)
    request.info.should be_an_instance_of(HealthVault::WCData::Methods::GetThingType::Info)
    request.info.add_section('columns')
    result = request.send
    result.info.should be_an_instance_of(HealthVault::WCData::Methods::Response::GetThingType::Info)
    result.info.thing_type.should_not be_empty
    result.info.thing_type.each {|t| t.should be_an_instance_of(HealthVault::WCData::Methods::Response::GetThingType::ThingTypeInfo)}
  end
  
  it "should get vocabularies without authenticating" do
    request = Request.create("GetVocabulary", @connection)
    request.info.should be_an_instance_of(HealthVault::WCData::Methods::GetVocabulary::Info)
    result = request.send
    result.info.should be_an_instance_of(HealthVault::WCData::Methods::Response::GetVocabulary::Info)
  end
  
end

