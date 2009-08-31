# -*- ruby -*-
#--
# Copyright 2008 Danny Coates, Ashkan Farhadtouski
# All rights reserved.
# See LICENSE for permissions.
#++

require 'rexml/document'
require 'erb'
require File.dirname(__FILE__) + "/../wc_data/complex_type"
require File.dirname(__FILE__) + "/../config"
require File.dirname(__FILE__) + "/../utils/string_utils"

module HealthVault
  module CodeGeneration
    class XSDParser
      include StringUtils
      include REXML
      
      def initialize(filename)
        cdir = File.dirname(__FILE__)
        @filename = filename
        @simple_template = cdir + "/../templates/simple_type_template.erb"
        @complex_template = cdir + "/../templates/complex_type_template.erb"
        @thing_ex_template = cdir + "/../templates/thing_class_extension_template.erb"
        @file_path = cdir + "/../wc_data/generated"
        @logger = Configuration.instance.logger
      end
      
      def add_thing(filename)
        file = File.open(filename)
        @xml = Document.new(file)
        tgt_namespace = @xml.root.attribute('targetNamespace').to_s
        mods = Array.new
        begin
          mods = (tgt_namespace.match(/urn\:com\.microsoft\.wc\.(.*)/)[1]).split('.')
         
          guid = XPath.first(@xml.root, "//type-id").text.to_s#@xml.root.get_elements('annotation/documentation/type-id')[0].text.to_s
          el = @xml.root.get_elements('element')[0]
          wrapper_class = REXML::XPath.first(@xml,"//wrapper-class-name")
          if wrapper_class && wrapper_class.text && mods[0] == "thing" && underscore(wrapper_class.text) != underscore(mods[1])
             mods[1] = wrapper_class.text
           end
          cname =   el.attribute('name').to_s
          type = el.attribute('type').to_s
          class_path = "HealthVault::WCData::"
          if type.empty?
            class_path += (mods.collect {|s| classify(s)}).join('::') + "::" + classify(cname)
          else
           
            namespaces = get_namespaces
            class_path = get_class_path(wrapper_class ? wrapper_class.text : type)
            
              
          end
          @thing_hash ||= Hash.new
          @thing_hash[guid] = class_path
        rescue
          @logger.error "Not a HealthVault targetNamespace, can't parse #{@filename}"
          return
        end
      end
      
      def create_things
        class_hash = @thing_hash
        result = ""
        File.open(File.dirname(__FILE__) + "/../wc_data/thing.rb", 'w') do |f|
          e = ERB.new(File.read(@thing_ex_template), 0, '<>', 'result')
          e.result(binding)
          f << result
        end
      end
      
      # creates ruby class files for the types defined in the xsd
      def run(test = :no)
        @test = test
        file = File.open(@filename)
        @xml = Document.new(file)
        @namespaces = get_namespaces
        @namespace = @xml.root.attribute('targetNamespace').to_s
        begin
          @modules = (@namespace.match(/urn\:com\.microsoft\.wc\.(.*)/)[1]).split('.')
          
           wrapper_class = REXML::XPath.first(@xml,"//wrapper-class-name")
           puts wrapper_class.text if wrapper_class
           puts @modules.inspect
           puts underscore(wrapper_class.text) != underscore(@modules[1]) if wrapper_class
            if wrapper_class && wrapper_class.text && @modules[0] == "thing" && underscore(wrapper_class.text) != underscore(@modules[1])
               @modules[1] = wrapper_class.text
             end
        rescue
          @logger.error "Not a HealthVault targetNamespace, can't parse #{@filename}"
          return
        end
        create_directories
        root = @xml.root
        root.elements.each do |e|
          @element_order = 0
          case e.name
          when 'simpleType'
            create_simple_type(e)
          when 'complexType'
            create_complex_type(e)
          when 'element'
            #root elements
            parse_element(e)
            #            type = e.attribute('type').to_s
            #            #if the element has a type we can skip it
            #            #since we are only looking for new types
            #            next unless type.empty?
            #            #this element defines an anonymous type
            #            cname = e.attribute('name').to_s
            #            e.elements.each do |child|
            #              case child.name
            #              when 'simpleType'
            #                create_simple_type(child, cname)
            #              when 'complexType'
            #                create_complex_type(child, cname)
            #              end
            #            end
          end
        end
      end
      
      private
      
      # get the wc namespaces used in this document
      def get_namespaces
        namespaces = Hash.new
        root = @xml.root
        root_attributes = root.attributes
        root_attributes.each do |name, value|
          if name.include?('xmlns:')
            m = value.match(/urn\:com\.microsoft\.wc\.(.*)/)
            unless m.nil?
              mod = (m[1].split('.').collect {|s| classify(s)}).join('::')
              namespaces[name.split(':')[-1]]= mod
            end
          end
        end
        return namespaces
      end
      
      # create the directory structure from the xsd namespace
      def create_directories
        unless File.exists?(@file_path)
          Dir.mkdir(@file_path)
        end        
        @modules.each do |m| 
        
          @file_path << "/#{underscore(m)}"
          unless File.exists?(@file_path)
            Dir.mkdir(@file_path)
          end
        end
      end
      
      # creates a ruby class file that extends SimpleType
      def create_simple_type(e, cname = '')
        cname = e.attribute('name').to_s if cname.empty?
        cname = 'info' if cname.empty?
        file_name = underscore(cname)
        class_name = classify(cname)
        restrictions = Hash.new
        e.get_elements('restriction').each do |r|
          restrictions = restrictions.merge(parse_restriction(r))
        end
        create_class_from_template(@simple_template, file_name, class_name, cname.downcase, "", restrictions)
      end
      
      # creates a ruby class file that extends ComplexType
      def create_complex_type(e, cname = '')
        cname = e.attribute('name').to_s if cname.empty?
        children = Array.new
        file_name = underscore(cname)
        class_name = classify(cname)
        cdoc = doc(e)
        e.elements.each do |child|
          case child.name
          when 'sequence'
            children += parse_sequence(child)
          when 'simpleContent'
            children += parse_simple_content(child)
          when 'attribute'
            n = parse_attribute(child)
            children << n unless n.nil?
          when 'choice'
            children += parse_choice(child)
          end
        end
        create_class_from_template(@complex_template, file_name, class_name, cname.downcase, cdoc, children)
      end
      
      #returns an Array of child node Hashes
      def parse_sequence(e)
        children = Array.new
        e.elements.each do |child|
          case child.name
          when 'element'
            n = parse_element(child)
            children << n unless n.nil?
          when 'choice'
            children += parse_choice(child)
            #TODO parse 'any' nodes
          when 'any'
            children << parse_any(child)
            next
          end
        end
        return children
      end
      
      #returns an Array of child node Hashes
      def parse_simple_content(e)
        children = Array.new
        e.elements.each do |child|
          case child.name
          when 'extension'
            children += parse_extension(child)
          end
        end
        return children
      end
      
      #returns an Array of child node Hashes
      def parse_extension(e)
        children = Array.new
        class_path = get_class_path(e.attribute('base').to_s)
        children << {:name => 'data',
          :class => class_path,
          :min => '1',
          :max => '1',
          :order => 0,
          :doc => doc(e),
          :type => :extension
        }
        e.elements.each do |child|
          case child.name
          when 'attribute'
            a = parse_attribute(child)
            children << a unless a.nil?
          end
        end
        return children
      end
      
      def parse_any(e)
        min = e.attribute('minOccurs').to_s
        max = e.attribute('maxOccurs').to_s
        max = '1' if max.empty?
        #TODO: make unbounded really unbounded
        max = '999999' if max == 'unbounded'
        min = '1' if min.empty?
        @element_order += 1
        return {:name => 'anything',
          :class => HealthVault::WCData::ComplexType,
          :min => min,
          :max => max,
          :order => @element_order,
          :doc => doc(e),
          :type => :extension,
          :choice => 0
        }
      end
      
      #returns a Hash of attribute properties for the template
      def parse_attribute(e)
        return {:name => e.attribute('name').to_s,
          :class => get_class_path(e.attribute('type').to_s),
          :min => e.attribute('use').to_s == 'required' ? '1' : '0',
          :max => '1',
          :order => 0,
          :doc => doc(e),
          :type => :attribute
        }
      end
      
      #returns an Array of parsed elements (parse_element)
      def parse_choice(e)
        children = Array.new
        min = e.attribute('minOccurs').to_s
        max = e.attribute('maxOccurs').to_s
        choice_id = rand(1 << 29).to_s
        e.elements.each do |child|
          case child.name
          when 'element'
            n = parse_element(child, choice_id, min, max)
            children << n unless n.nil?
          end
        end
        return children
      end
      
      #returns a Hash of element properties for the template
      def parse_element(e, choice = nil, min = '', max = '')
        type = e.attribute('type').to_s
        cname = e.attribute('name').to_s
        #TODO decide what to do with ref elements
        return nil if cname.empty?
        if type.empty?
          #this element defines an anonymous type
          e.elements.each do |child|
            case child.name
            when 'simpleType'
              create_simple_type(child, cname)
            when 'complexType'
              create_complex_type(child, cname)
            end
          end
        end
        class_path = get_class_path(type)
        max = e.attribute('maxOccurs').to_s if max.empty?
        min = e.attribute('minOccurs').to_s if min.empty?
        max = '1' if max.empty?
        #TODO: make unbounded really unbounded
        max = '999999' if max == 'unbounded'
        min = '1' if min.empty?
        @element_order += 1
        return {:name => cname,
          :class => class_path,
          :min => min,
          :max => max,
          :doc => doc(e),
          :choice => choice,
          :type => :element,
          :order => @element_order
        }
      end
      
      def parse_restriction(e)
        restrictions = Hash.new
        restrictions['base'] = e.attribute('base').to_s
        e.elements.each do |child|
          name = child.name
          case name
          when 'enumeration'
            restrictions[name] ||= Array.new
            restrictions[name] << child.attribute('value').to_s
          when 'annotation'
            #noop
          else
            restrictions[name] = child.attribute('value').to_s
          end
        end
        return restrictions
      end
      
      # returns a string from parsing the annotation/documentation of the given node
      def doc(node)
        result = ""
        node.get_elements('annotation/documentation').each do |d|
          d.elements.each do |e|
            t = e.text.to_s.gsub(/\r|\n/, '').squeeze(' ').strip
            unless t.empty?
              result << "#<b>#{e.name}</b>: #{t}\n" 
            end
          end
        end
        return result
      end
      
      # get the full classpath for the given type attribute
      def get_class_path(type)
        base = "HealthVault::WCData::"
        comp = type.split(':')
        @namespaces.each do |k,v|
          if comp[0] == k
            return base + v + "::#{classify(type.gsub(/.*:/, ''))}"
          end
        end
        #TODO: parse xsd primatives
        return "String"#base + classify(type.gsub(/wc-.*:/, ''))
      end
      
      # generate the .rb file with the given template
      def create_class_from_template(template, file_name, class_name, tag_name, cdoc, children = [])
        result = ''
        modules = @modules
        if @test == :yes
          e = ERB.new(File.read(template), 0, '<>', 'result')
          e.run(binding)
        else
          File.open(@file_path + "/#{file_name}.rb", 'w') do |f|
            e = ERB.new(File.read(template), 0, '<>', 'result')
            e.result(binding)
            f << result
          end
        end
      end
      
    end
  end
end
