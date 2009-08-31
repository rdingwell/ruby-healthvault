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
  module Annotation
  
      class Annotation < ComplexType
        
     
        
        
       
        #<b>REQUIRED</b>
        #<b>summary</b>: The date and time of the annotation.
#<em>value</em> is a HealthVault::WCData::Dates::Datetime
        def when=(value)
          @children['when'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Dates::Datetime
        def when
          return @children['when'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The text content of this medical annotation.
#<em>value</em> is a String
        def content=(value)
          @children['content'][:value] = value
        end
        
        #<b>returns</b>: a String
        def content
          return @children['content'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The author of this medical annotation.
#<em>value</em> is a HealthVault::WCData::Thing::Types::Person
        def author=(value)
          @children['author'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Person
        def author
          return @children['author'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: A classification for this medical annotation.
#<em>value</em> is a String
        def classification=(value)
          @children['classification'][:value] = value
        end
        
        #<b>returns</b>: a String
        def classification
          return @children['classification'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: A document index for this medical annotation.
#<em>value</em> is a String
        def index=(value)
          @children['index'][:value] = value
        end
        
        #<b>returns</b>: a String
        def index
          return @children['index'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: A document version for this medical annotation.
#<em>value</em> is a String
        def version=(value)
          @children['version'][:value] = value
        end
        
        #<b>returns</b>: a String
        def version
          return @children['version'][:value]
        end
       
  
      
        def initialize
          super
          self.tag_name = 'annotation'
        
          
          @children['when'] = {:name => 'when', :class => HealthVault::WCData::Dates::Datetime, :value => nil, :min => 1, :max => 1, :order => 1, :place => :element, :choice => 0 }
            
          @children['when'][:value] = HealthVault::WCData::Dates::Datetime.new
            
          
        
          
          @children['content'] = {:name => 'content', :class => String, :value => nil, :min => 0, :max => 1, :order => 2, :place => :element, :choice => 0 }
            
          
        
          
          @children['author'] = {:name => 'author', :class => HealthVault::WCData::Thing::Types::Person, :value => nil, :min => 0, :max => 1, :order => 3, :place => :element, :choice => 0 }
            
          
        
          
          @children['classification'] = {:name => 'classification', :class => String, :value => nil, :min => 0, :max => 1, :order => 4, :place => :element, :choice => 0 }
            
          
        
          
          @children['index'] = {:name => 'index', :class => String, :value => nil, :min => 0, :max => 1, :order => 5, :place => :element, :choice => 0 }
            
          
        
          
          @children['version'] = {:name => 'version', :class => String, :value => nil, :min => 0, :max => 1, :order => 6, :place => :element, :choice => 0 }
            
          
        
        end
      end
  end
  end
  
  end
end
