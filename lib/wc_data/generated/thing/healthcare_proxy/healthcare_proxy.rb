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
  module Healthcareproxy
  
      class Healthcareproxy < ComplexType
        
     
        
        
       
        #<b>REQUIRED</b>
        #<b>summary</b>: The date and time of the proxy.
#<em>value</em> is a HealthVault::WCData::Dates::Datetime
        def when=(value)
          @children['when'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Dates::Datetime
        def when
          return @children['when'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: Primary contact for healthcare proxy.
#<em>value</em> is a HealthVault::WCData::Thing::Types::Person
        def proxy=(value)
          @children['proxy'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Person
        def proxy
          return @children['proxy'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: Alternative contact for healthcare proxy.
#<em>value</em> is a HealthVault::WCData::Thing::Types::Person
        def alternate=(value)
          @children['alternate'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Person
        def alternate
          return @children['alternate'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: Primary witness of healthcare proxy.
#<em>value</em> is a HealthVault::WCData::Thing::Types::Person
        def primary_witness=(value)
          @children['primary-witness'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Person
        def primary_witness
          return @children['primary-witness'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: Secondary witness of healthcare proxy.
#<em>value</em> is a HealthVault::WCData::Thing::Types::Person
        def secondary_witness=(value)
          @children['secondary-witness'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Person
        def secondary_witness
          return @children['secondary-witness'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: Free form content of healthcare proxy.
#<em>value</em> is a String
        def content=(value)
          @children['content'][:value] = value
        end
        
        #<b>returns</b>: a String
        def content
          return @children['content'][:value]
        end
       
  
      
        def initialize
          super
          self.tag_name = 'healthcare-proxy'
        
          
          @children['when'] = {:name => 'when', :class => HealthVault::WCData::Dates::Datetime, :value => nil, :min => 1, :max => 1, :order => 1, :place => :element, :choice => 0 }
            
          @children['when'][:value] = HealthVault::WCData::Dates::Datetime.new
            
          
        
          
          @children['proxy'] = {:name => 'proxy', :class => HealthVault::WCData::Thing::Types::Person, :value => nil, :min => 0, :max => 1, :order => 2, :place => :element, :choice => 0 }
            
          
        
          
          @children['alternate'] = {:name => 'alternate', :class => HealthVault::WCData::Thing::Types::Person, :value => nil, :min => 0, :max => 1, :order => 3, :place => :element, :choice => 0 }
            
          
        
          
          @children['primary-witness'] = {:name => 'primary-witness', :class => HealthVault::WCData::Thing::Types::Person, :value => nil, :min => 0, :max => 1, :order => 4, :place => :element, :choice => 0 }
            
          
        
          
          @children['secondary-witness'] = {:name => 'secondary-witness', :class => HealthVault::WCData::Thing::Types::Person, :value => nil, :min => 0, :max => 1, :order => 5, :place => :element, :choice => 0 }
            
          
        
          
          @children['content'] = {:name => 'content', :class => String, :value => nil, :min => 0, :max => 1, :order => 6, :place => :element, :choice => 0 }
            
          
        
        end
      end
  end
  end
  
  end
end
