# -*- ruby -*-
#--
# Copyright 2008 Danny Coates, Ashkan Farhadtouski
# All rights reserved.
# See LICENSE for permissions.
#++

require 'rexml/document'
require 'date'
require File.dirname(__FILE__) + '/utils/string_utils'
require File.dirname(__FILE__) + '/wc_data/init'

# HealtVault doesn't adhere to valid xml standards.
# Attribute values must be in double quotes to be parseable
# So we redefine REXML::Attribute.to_string to accommodate
REXML::Attribute.class_eval {def to_string() "#@expanded_name=\"#{to_s().gsub(/"/, '&quot;')}\"" end}

module HealthVault
  class Request < HealthVault::WCData::ComplexType
    include WCData
    include REXML
    include StringUtils
    
    # HealthVault::WCData::Types::HMACFinalized
    def auth=(value)
      @children['auth'][:value] = value
    end
        
    def auth
      return @children['auth'][:value]
    end

    # HealthVault::WCData::Request::Header
    def header=(value)
      @children['header'][:value] = value
    end
        
    def header
      return @children['header'][:value]
    end

    # HealthVault::WCData::Request::Info
    def info=(value)
      @children['info'][:value] = value
    end
        
    def info
      return @children['info'][:value]
    end
      
    def initialize(connection)
      super()
      @connection = connection  
      @children['auth'] = {:name => 'auth', :class => HealthVault::WCData::Types::HMACFinalized, :value => nil, :min => 0, :max => 1, :order => 1, :place => :element }
      @children['header'] = {:name => 'header', :class => HealthVault::WCData::Request::Header, :value => nil, :min => 1, :max => 1, :order => 2, :place => :element }
      @children['header'][:value] = WCData::Request::Header.new
      @children['info'] = {:name => 'info', :class => HealthVault::WCData::Request::Info, :value => nil, :min => 1, :max => 1, :order => 3, :place => :element }  
    end
    
    def self.create(method_name, connection)
      request = Request.new(connection) 
      request.header.method = method_name
      request.header.method_version = "1"
      request.header.language = "en"
      request.header.country = "US"
      request.header.msg_time = DateTime.now
      request.header.msg_ttl = 29100
      request.header.version = "0.0.0.1"
      request.info = request.new_request_info
      return request
    end
    
    def new_request_info
      begin
        class_new = "HealthVault::WCData::Methods::#{header.method}::Info.new"
        return eval(class_new)
      rescue
        Configuration.instance.logger.error "No Info class for #{header.method}"
        return HealthVault::WCData::RawInfoXml.new
      end
    end
    
    def element
      e = Element.new('wc-request:request')
      e.add_namespace("wc-request", "urn:com.microsoft.wc.request")
      super(e)
    end
    
    def send
      if @connection.authenticated?
        header.info_hash = Types::HashFinalized.new
        header.info_hash.hash_data = Types::HashFinalizedData.new
        header.info_hash.hash_data.alg_name = "SHA1"
        header.info_hash.hash_data.data = CryptoUtils.encode64(CryptoUtils.digest(info.element.to_s))
        header.auth_session = WCData::Request::AuthenticatedSessionInfo.new
        header.auth_session.auth_token = @connection.session_token
        header.auth_session.user_auth_token = @connection.user_auth_token #or offline_person_info
        #INFO: call the auth= method, not create an auth variable
        self.auth = Types::HMACFinalized.new
        auth.hmac_data = Types::HMACFinalizedData.new
        auth.hmac_data.alg_name = "HMACSHA1"
        auth.hmac_data.data = CryptoUtils.encode64(CryptoUtils.hmac(@connection.shared_secret, header.element.to_s)) 
      else
        header.app_id = @connection.application.id
      end
      #if self.valid?
      return @connection.send(self)
      #else
      #  raise StandardError.new("request is not valid")
      #end      
    end
  end
end