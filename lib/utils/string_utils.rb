# -*- ruby -*-
#--
# Copyright 2008 Danny Coates, Ashkan Farhadtouski
# All rights reserved.
# See LICENSE for permissions.
#++

module HealthVault
  module StringUtils
    def camelize(string)
      result = ""
      parts = string.split('_')
      result << parts.first.downcase
      parts[1..-1].each {|s| result << s.downcase.capitalize}
      return result
    end
      
    def underscore(camel_cased_word)
      return camel_cased_word.to_s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end
    
    def classify(string)
      if string.length > 1
        class_name =  string[/./].upcase + string[1..-1]
      else
        class_name = string
      end
      return class_name.gsub('-', '')
    end
  end
end
