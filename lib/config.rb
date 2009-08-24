# -*- ruby -*-
#--
# Copyright 2008 Danny Coates, Ashkan Farhadtouski
# All rights reserved.
# See LICENSE for permissions.
#++

require 'logger'
require 'singleton'

module HealthVault
  class Configuration
    include Singleton
    attr_accessor :app_id, :cert_file, :cert_pass, :shell_url, :hv_url, :logger
    
    #default values to the HelloWorld sample.
    #theses should be set by your application
    #using HealthVault::Configuration.instance accessor methods
    def initialize
      @app_id = "05a059c9-c309-46af-9b86-b06d42510550"
      @cert_file = File.dirname(__FILE__) + "/../bin/certs/helloWorld.pem"
      @cert_pass = ""
      @shell_url = "https://account.healthvault-ppe.com"
      @hv_url = "https://platform.healthvault-ppe.com/platform/wildcat.ashx"
      @logger = Logger.new("hv.log")
    end
  end
end