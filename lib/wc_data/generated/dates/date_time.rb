# -*- ruby -*-
#--
# Copyright 2008 Danny Coates, Ashkan Farhadtouski
# All rights reserved.
# See LICENSE for permissions.
#++
# AUTOGENERATED ComplexType

module HealthVault
  module WCData
  module Dates
  
      class Datetime < ComplexType
        
     
        
        
       
        #<b>REQUIRED</b>
        #<em>value</em> is a HealthVault::WCData::Dates::Date
        def date=(value)
          @children['date'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Dates::Date
        def date
          return @children['date'][:value]
        end
       
     
        
        
       
        
        #<em>value</em> is a HealthVault::WCData::Dates::Time
        def time=(value)
          @children['time'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Dates::Time
        def time
          return @children['time'][:value]
        end
       
     
        
        
       
        
        #<em>value</em> is a HealthVault::WCData::Types::Codablevalue
        def tz=(value)
          @children['tz'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Types::Codablevalue
        def tz
          return @children['tz'][:value]
        end
       
  
      
        def initialize
          super
          self.tag_name = 'date-time'
        
          
          @children['date'] = {:name => 'date', :class => HealthVault::WCData::Dates::Date, :value => nil, :min => 1, :max => 1, :order => 1, :place => :element, :choice => 0 }
            
          @children['date'][:value] = HealthVault::WCData::Dates::Date.new
            
          
        
          
          @children['time'] = {:name => 'time', :class => HealthVault::WCData::Dates::Time, :value => nil, :min => 0, :max => 1, :order => 2, :place => :element, :choice => 0 }
            
          
        
          
          @children['tz'] = {:name => 'tz', :class => HealthVault::WCData::Types::Codablevalue, :value => nil, :min => 0, :max => 1, :order => 3, :place => :element, :choice => 0 }
            
          
        
        end
      end
  end
  
  end
end
