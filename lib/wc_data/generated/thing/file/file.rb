# -*- ruby -*-
#--
# Copyright 2008 Danny Coates, Ashkan Farhadtouski
# All rights reserved.
# See LICENSE for permissions.
#++
# AUTOGENERATED ComplexType

module HealthVault
  module WCData
  module Thing
  module File
  
      class File < ComplexType
        
     
        
        
       
        #<b>REQUIRED</b>
        #<b>summary</b>: The original name of the file, with extension if available.
#<em>value</em> is a HealthVault::WCData::Types::String255
        def name=(value)
          @children['name'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Types::String255
        def name
          return @children['name'][:value]
        end
       
     
        
        
       
        #<b>REQUIRED</b>
        #<b>summary</b>: The size of the file in bytes.
#<em>value</em> is a String
        def size=(value)
          @children['size'][:value] = value
        end
        
        #<b>returns</b>: a String
        def size
          return @children['size'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The content type of the file.
#<b>remarks</b>: If empty, Microsoft HealthVault will assume a content type of application/octet-stream.
#<em>value</em> is a HealthVault::WCData::Thing::Types::Codablevalue
        def content_type=(value)
          @children['content-type'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Codablevalue
        def content_type
          return @children['content-type'][:value]
        end
       
  
      
        def initialize
          super
          self.tag_name = 'file'
        
          
          @children['name'] = {:name => 'name', :class => HealthVault::WCData::Types::String255, :value => nil, :min => 1, :max => 1, :order => 1, :place => :element, :choice => 0 }
            
          @children['name'][:value] = HealthVault::WCData::Types::String255.new
            
          
        
          
          @children['size'] = {:name => 'size', :class => String, :value => nil, :min => 1, :max => 1, :order => 2, :place => :element, :choice => 0 }
            
          @children['size'][:value] = String.new
            
          
        
          
          @children['content-type'] = {:name => 'content-type', :class => HealthVault::WCData::Thing::Types::Codablevalue, :value => nil, :min => 0, :max => 1, :order => 3, :place => :element, :choice => 0 }
            
          
        
        end
      end
  end
  end
  
  end
end
