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
  module HbA1C
  
      class HbA1C < ComplexType
        
     
        
        
       
        #<b>REQUIRED</b>
        #<b>summary</b>: The date and time the reading was taken.
#<em>value</em> is a HealthVault::WCData::Dates::Datetime
        def when=(value)
          @children['when'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Dates::Datetime
        def when
          return @children['when'][:value]
        end
       
     
        
        
       
        #<b>REQUIRED</b>
        #<b>summary</b>: The HbA1C measurement as a percentage.
#<em>value</em> is a HealthVault::WCData::Thing::Types::Percentage
        def value=(value)
          @children['value'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Percentage
        def value
          return @children['value'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The HbA1C reference method used for this measurement.
#<b>remarks</b>: The measurement of HbA1c in human blood is most important for the longterm control of the glycaemic state in diabetic patients. There is no internationally agreed assay measurement method.
#<b>preferred-vocabulary</b>: HbA1C-assay-method
#<em>value</em> is a HealthVault::WCData::Thing::Types::Codablevalue
        def hb_a1_c_assay_method=(value)
          @children['HbA1C-assay-method'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Codablevalue
        def hb_a1_c_assay_method
          return @children['HbA1C-assay-method'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The unique id or serial number for the measurment device.
#<b>remarks</b>: If available, this value can be used to correlate results.
#<em>value</em> is a String
        def device_id=(value)
          @children['device-id'][:value] = value
        end
        
        #<b>returns</b>: a String
        def device_id
          return @children['device-id'][:value]
        end
       
  
      
        def initialize
          super
          self.tag_name = 'hba1c'
        
          
          @children['when'] = {:name => 'when', :class => HealthVault::WCData::Dates::Datetime, :value => nil, :min => 1, :max => 1, :order => 1, :place => :element, :choice => 0 }
            
          @children['when'][:value] = HealthVault::WCData::Dates::Datetime.new
            
          
        
          
          @children['value'] = {:name => 'value', :class => HealthVault::WCData::Thing::Types::Percentage, :value => nil, :min => 1, :max => 1, :order => 2, :place => :element, :choice => 0 }
            
          @children['value'][:value] = HealthVault::WCData::Thing::Types::Percentage.new
            
          
        
          
          @children['HbA1C-assay-method'] = {:name => 'HbA1C-assay-method', :class => HealthVault::WCData::Thing::Types::Codablevalue, :value => nil, :min => 0, :max => 1, :order => 3, :place => :element, :choice => 0 }
            
          
        
          
          @children['device-id'] = {:name => 'device-id', :class => String, :value => nil, :min => 0, :max => 1, :order => 4, :place => :element, :choice => 0 }
            
          
        
        end
      end
  end
  end
  
  end
end
