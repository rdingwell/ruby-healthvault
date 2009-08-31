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
  module Types
  
      class Person < ComplexType
        
     
        
        
       
        #<b>REQUIRED</b>
        #<b>summary</b>: The name of the contact person.
#<em>value</em> is a HealthVault::WCData::Thing::Types::Name
        def name=(value)
          @children['name'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Name
        def name
          return @children['name'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The name of the organization the contact belongs to.
#<em>value</em> is a String
        def organization=(value)
          @children['organization'][:value] = value
        end
        
        #<b>returns</b>: a String
        def organization
          return @children['organization'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The person's professional training.
#<em>value</em> is a String
        def professional_training=(value)
          @children['professional-training'][:value] = value
        end
        
        #<b>returns</b>: a String
        def professional_training
          return @children['professional-training'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The identification number for the person in the organization.
#<em>value</em> is a String
        def id=(value)
          @children['id'][:value] = value
        end
        
        #<b>returns</b>: a String
        def id
          return @children['id'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: Information on how to contact the person.
#<em>value</em> is a HealthVault::WCData::Thing::Types::Contact
        def contact=(value)
          @children['contact'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Contact
        def contact
          return @children['contact'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The type of the contact person.
#<b>remarks</b>: A person may be an emergency contact, a health care provider, etc. The values should be taken from the Microsoft Health Lexicon vocabulary 'person-types'.
#<b>preferred-vocabulary</b>: person-types
#<em>value</em> is a HealthVault::WCData::Thing::Types::Codablevalue
        def type=(value)
          @children['type'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Codablevalue
        def type
          return @children['type'][:value]
        end
       
  
      
        def initialize
          super
          self.tag_name = 'person'
        
          
          @children['name'] = {:name => 'name', :class => HealthVault::WCData::Thing::Types::Name, :value => nil, :min => 1, :max => 1, :order => 1, :place => :element, :choice => 0 }
            
          @children['name'][:value] = HealthVault::WCData::Thing::Types::Name.new
            
          
        
          
          @children['organization'] = {:name => 'organization', :class => String, :value => nil, :min => 0, :max => 1, :order => 2, :place => :element, :choice => 0 }
            
          
        
          
          @children['professional-training'] = {:name => 'professional-training', :class => String, :value => nil, :min => 0, :max => 1, :order => 3, :place => :element, :choice => 0 }
            
          
        
          
          @children['id'] = {:name => 'id', :class => String, :value => nil, :min => 0, :max => 1, :order => 4, :place => :element, :choice => 0 }
            
          
        
          
          @children['contact'] = {:name => 'contact', :class => HealthVault::WCData::Thing::Types::Contact, :value => nil, :min => 0, :max => 1, :order => 5, :place => :element, :choice => 0 }
            
          
        
          
          @children['type'] = {:name => 'type', :class => HealthVault::WCData::Thing::Types::Codablevalue, :value => nil, :min => 0, :max => 1, :order => 6, :place => :element, :choice => 0 }
            
          
        
        end
      end
  end
  end
  
  end
end
