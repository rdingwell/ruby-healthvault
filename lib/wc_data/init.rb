# -*- ruby -*-
#--
# Copyright 2008 Danny Coates, Ashkan Farhadtouski
# All rights reserved.
# See LICENSE for permissions.
#++

dir = File.dirname(__FILE__) + '/generated'
require dir + '/../simple_type'
require dir + '/../complex_type'
require dir + '/../raw_info_xml'

def recurse_require(dir)
  Dir.foreach(dir) do |filename|
    f = dir + "/#{filename}"
    if File.directory?(f) && f[-1] != 46 #'.'
      recurse_require(f)
    elsif f.include?('.rb') && f != __FILE__
      require f
    end    
  end
end
recurse_require(dir)
# '/../thing' won't exist until generated
if File.exists?(dir + '/../thing.rb')
  require dir + '/../thing'
end
