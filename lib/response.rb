# -*- ruby -*-
#--
# Copyright 2008 Danny Coates, Ashkan Farhadtouski
# All rights reserved.
# See LICENSE for permissions.
#++

require 'rexml/document'
require File.dirname(__FILE__) + '/utils/string_utils'

module HealthVault
  class Response
    include REXML
    include StringUtils
    include WCData
    
    attr_reader :xml, :info
    
    def initialize(http_response)
      @http_response = http_response
      @xml = Document.new(@http_response.body)
      code = XPath.first(@xml, "//code").text
      if code.to_i > 0
        msg = XPath.first(@xml, "//error/message").text
        Configuration.instance.logger.error "ERRORCODE: #{code.to_s} MESSAGE: #{msg}"
        raise StandardError.new(msg)
      end
      Configuration.instance.logger.debug @xml.to_s
      info_node = XPath.first(@xml, '//wc:info')
      response_namespace = info_node.attribute('xmlns:wc').to_s
      m = response_namespace.match(/urn\:com\.microsoft\.wc\.(.*)/)
      if m.nil?
        @info = nil
      else
        begin
          mod = (m[1].split('.').collect {|s| classify(s)}).join('::') + "::Info.new"
          # eval may as well be called evil
          nfo = eval mod
          @info = nfo
          @info.parse_element(info_node)
        rescue => e
          puts e
          Configuration.instance.logger.error e
          @info = nil
        end
      end
    end
    
  end
end