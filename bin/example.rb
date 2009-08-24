#!/usr/bin/ruby
require File.dirname(__FILE__) + '/../lib/healthvault'
require File.dirname(__FILE__) + "/../spec/support/test_server"
include HealthVault

#The first thing we should do is set our Configuration.
#This example uses the defaults from config.rb, so nothing needs to be done
#To make changes follow this commented example:
#
#Configuration.instance.app_id = "05a059c9-c309-46af-9b86-b06d42510550"
#Configuration.instance.logger = RAILS_DEFAULT_LOGGER

#Then we need an Application.
#Application.default will use settings from Configuration,
#or you can use Application.new to use other parameters
app = Application.default

#Once we have an Application, we can create Connections.
#A connection contains the session_token and shared_secret
#for maintaining a session with HealthVault. It can also hold
#the user_auth_token of a HealthVault user, and it can be serialized
#and saved for later, for instance, in a Rails session
connection = app.create_connection
#Authenticating a connection creates a shared_secret and session_token
#with HealthVault using the Application.id and certificate as credentials.
#Most useful HealthVault methods require an authenticated connection.
connection.authenticate
puts 'authenticated application...'

#Requests are used to communicate with HealthVault.
#They are created with Request.create passing in the name of the method,
#and the connection. Depending on the method, additional info may be required
#before sending the request.
request = Request.create("GetVocabulary", connection)
request.info.vocabulary_parameters = WCData::Methods::GetVocabulary::VocabularyParameters.new
request.info.vocabulary_parameters.add_vocabulary_key WCData::Vocab::VocabularyKey.new
request.info.vocabulary_parameters.vocabulary_key[0].name = "thing-types"
request.info.vocabulary_parameters.vocabulary_key[0].family = "wc"
request.info.vocabulary_parameters.vocabulary_key[0].version = '1'
request.info.vocabulary_parameters.fixed_culture = 'true'
#the return value of request.send is a Response object if the request succeeds,
#otherwise a StandardError is raised.
result = request.send
puts 'got thing-type vocabulary...'

#The TestServer allows us to authenticate a user through the browser.
#It should not be used for anything but testing.
t = TestServer.new
t.open_login
t.wait_for_auth

#We set the user_auth_token of connection. Now we can make requests that require
#the user to be logged in.
connection.user_auth_token = t.auth_token

#now that the user is logged in, we can get their info
request = Request.create("GetPersonInfo", connection)
result = request.send
#selected_record_id is an important field used by many HealthVault methods.
#Once we have it, it should be added to our Request.header.record_id on
#future requests like GetThings, PutThings, etc.
record_id = result.info.person_info.selected_record_id

puts 'got person info for...'
puts result.info.person_info.name
puts 'with record id...'
puts record_id



request = Request.create("GetThings", connection)
request.header.record_id = record_id
request.info.add_group(WCData::Methods::GetThings::ThingRequestGroup.new)
request.info.group[0].format = WCData::Methods::GetThings::ThingFormatSpec.new
request.info.group[0].format.add_xml("")
request.info.group[0].format.add_section("core")
request.info.group[0].add_filter(WCData::Methods::GetThings::ThingFilterSpec.new)
request.info.group[0].filter[0].xpath="/"
res = request.send
puts res.xml.to_s
#request = Request.create("GetThings", connection)
#request.header.record_id = record_id
#request.info.add_group(WCData::Methods::GetThings::ThingRequestGroup.new)
#request.info.group[0].format = WCData::Methods::GetThings::ThingFormatSpec.new
#request.info.group[0].format.add_xml("")
#request.info.group[0].format.add_section("core")
#request.info.group[0].add_filter(WCData::Methods::GetThings::ThingFilterSpec.new)
#request.info.group[0].filter[0].add_type_id("3d34d87e-7fc1-4153-800f-f56592cb0d17")
#
#result = request.send
#puts result.info.group[0].thing[0].data_xml[0].value.kg.to_s
#puts result.xml
