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
  module Diabeticprofile
  
      class TargetGlucoseZone < ComplexType
        
     
        
        
       
        #<b>REQUIRED</b>
        #<b>summary</b>: The lower boundary of the glucose zone.
#<em>value</em> is a HealthVault::WCData::Thing::Diabeticprofile::ZoneBoundary
        def lower_bound=(value)
          @children['lower-bound'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Diabeticprofile::ZoneBoundary
        def lower_bound
          return @children['lower-bound'][:value]
        end
       
     
        
        
       
        #<b>REQUIRED</b>
        #<b>summary</b>: The upper boundary of the glucose zone.
#<em>value</em> is a HealthVault::WCData::Thing::Diabeticprofile::ZoneBoundary
        def upper_bound=(value)
          @children['upper-bound'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Diabeticprofile::ZoneBoundary
        def upper_bound
          return @children['upper-bound'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The name of the glucose zone.
#<b>remarks</b>: The name is usually arbitrary. It is used by the person to easily identify the zone without having to remember the boundaries. The name is often represented relative to means.
#<em>value</em> is a String
        def name=(value)
          @children['name'][:value] = value
        end
        
        #<b>returns</b>: a String
        def name
          return @children['name'][:value]
        end
       
  
      
        def initialize
          super
          self.tag_name = 'targetglucosezone'
        
          
          @children['lower-bound'] = {:name => 'lower-bound', :class => HealthVault::WCData::Thing::Diabeticprofile::ZoneBoundary, :value => nil, :min => 1, :max => 1, :order => 1, :place => :element, :choice => 0 }
            
          @children['lower-bound'][:value] = HealthVault::WCData::Thing::Diabeticprofile::ZoneBoundary.new
            
          
        
          
          @children['upper-bound'] = {:name => 'upper-bound', :class => HealthVault::WCData::Thing::Diabeticprofile::ZoneBoundary, :value => nil, :min => 1, :max => 1, :order => 2, :place => :element, :choice => 0 }
            
          @children['upper-bound'][:value] = HealthVault::WCData::Thing::Diabeticprofile::ZoneBoundary.new
            
          
        
          
          @children['name'] = {:name => 'name', :class => String, :value => nil, :min => 0, :max => 1, :order => 0, :place => :attribute, :choice => 0 }
            
          
        
        end
      end
  end
  end
  
  end
end
