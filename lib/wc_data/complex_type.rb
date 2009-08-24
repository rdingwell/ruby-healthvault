# -*- ruby -*-
#--
# Copyright 2008 Danny Coates, Ashkan Farhadtouski
# All rights reserved.
# See LICENSE for permissions.
#++

require 'rexml/document'

module HealthVault
  module WCData
    class ComplexType
      include REXML
      attr_accessor :tag_name
      
      def initialize
        @children = Hash.new
      end
      
      def required_elements
        return query_elements {|v| v[:min] > 0}
      end
      
      def optional_elements
        return query_elements {|v| v[:min] == 0}
      end
      
      def query_elements
        result = Array.new
        if block_given?
          @children.each do |key, value|
            if yield value
              result << key
            end
          end
        else
          result = @children.keys
        end
        return result        
      end

      # construct REXML::Element tree from children
      def element(container = nil)
        #cname = self.class.to_s
        my_name = tag_name.to_s.strip.downcase#cname.split('::')[-1].downcase#
        if container.nil?
          me = Element.new(my_name)
        elsif container.is_a?(String)
          me = Element.new(container)
        else
          me = container
        end
        elements = @children.values.sort{|a,b| a[:order] <=> b[:order]}
        elements.each do |el|
          val = el[:value]
          next if val.nil?
          if val.is_a?(Array)
            val.each do |v|
              sub_element(el[:name], v, me)
            end
          else
            if el[:place] == :extension
              sub_element(el[:name], val, me, false)
            elsif el[:place] == :attribute
              me.add_attribute(el[:name], val.to_s)
            else
              sub_element(el[:name], val, me)
            end
          end
        end
        return me
      end
      
      # parse WCData from the given xml element
      def parse_element(e)
        # parse elements
        e.elements.each do |child|
          node = child.name
          if @children[node].nil?
            begin
              unless @children['anything'].nil?
                #see if the parent is a 'thing'
                types = e.parent.get_elements('type-id')
                unless types.empty?
                  type_guid = types[0].text.to_s
                  type = WCData::Thing::Thing.guid_to_class(type_guid)
                  #add_new_to_children(@children['anything'][:value], child, type)  
                  x = type.new
                  #TODO make SimpleTypes behave like their base types
                  #<HACK>
                  if x.is_a?(SimpleType) || x.is_a?(String)
                    x = child.text
                  end
                  #</HACK>
                  if x.respond_to?(:parse_element)
                    x.parse_element(child)
                  end
                  @children['anything'][:class] = type
                  if @children['anything'][:value].is_a?(Array)
                    @children['anything'][:value] << x
                  else
                    @children['anything'][:value] = x
                  end                
                end
              end
            rescue => err
              Configuration.instance.logger.error err
            end
            # unknown node type
            Configuration.instance.logger.debug "unknown node of #{node} for #{self.class.to_s}"
          else
            #add_new_to_children(@children[node][:value],child, @children[node][:class])
            x = @children[node][:class].new
            #TODO make SimpleTypes behave like their base types
            #<HACK>
            if x.is_a?(SimpleType) || x.is_a?(String)
              x = child.text
            end
            #</HACK>
            if x.respond_to?(:parse_element)
              x.parse_element(child)
            end
            if @children[node][:value].is_a?(Array)
              @children[node][:value] << x
            else
              @children[node][:value] = x
            end
          end
        end       
        # parse inner text
        if !@children['data'].nil? && !e.text.empty?
          @children['data'][:value] = e.text
        end
        # parse attributes
        e.attributes.each_attribute do |attr|
          name = attr.name
          if @children[name].nil?
            # unknown attribute type
            Configuration.instance.logger.debug "unknown attribute of #{name} for #{self.class.to_s}"
          else
            @children[name][:value] = attr.value.to_s
          end
        end
      end
      
      def add_new_to_children(target, node, klass)
        x = klass.new
        #TODO make SimpleTypes behave like their base types
        #<HACK>
        if x.is_a?(SimpleType) || x.is_a?(String)
          x = node.text
        end
        #</HACK>
        if x.respond_to?(:parse_element)
          x.parse_element(node)
        end
        if target.is_a?(Array)
          target << x
        else
          target = x
        end
      end
      
      def valid?
        valid = true
        choices = Hash.new
        @children.values.each do |child|
          if child[:place] == :element && child[:choice].to_i > 0
            choices[child[:choice]] ||= false
            #TODO: validate choices
          elsif child[:min] > 1
            len = child[:value].length
            valid = valid && (len > child[:min])
            valid = valid && (len < child[:max])
            child[:value].each do |v|
              break if !valid
              begin
                if child[:class].superclass == ComplexType
                  valid = valid && v.valid?
                elsif child[:class].superclass == SimpleType
                  valid = valid && child[:class].valid?(v)
                else
                  valid = valid && !(v.nil? || v.to_s.empty?)
                end
              rescue => e
                Configuration.instance.logger.error e
                valid = false
                break
              end
            end
          elsif child[:min] == 1
            #TODO extract the checks to a seperate method
            begin
              if child[:class].superclass == ComplexType
                valid = valid && child[:value].valid?
              elsif child[:class].superclass == SimpleType
                valid = valid && child[:class].valid?(child[:value])
              else
                valid = valid && !(child[:value].nil? || child[:value].to_s.empty?)
              end
            rescue => e
              Configuration.instance.logger.error e
              valid = false
              break
            end
          end          
        end
        return valid
      end
      
      # xml string
      def to_s
        return element.to_s
      end
      
      def method_missing(name, *args, &blk)
        #For more ease of use, forward method calls for
        #complexTypes that contain 'anything' nodes
        #to the 'anything', i.e. try to make 'anything' transparent
        unless @children['anything'].nil?
          #INFO: this will only work for single 'anythings'
          if @children['anything'][:value].respond_to?(name)
            return @children['anything'][:value].send(name, *args, &blk)            
          end          
        end
        raise NoMethodError
      end

      private

      def sub_element(name, obj, parent, tag = true)
        if tag
          n = Element.new(name, parent)
          if obj.is_a?(ComplexType)
            obj.element(n)
          else
            n.text = obj.to_s
          end
        else
          if obj.is_a?(ComplexType)
            parent << obj.element
          else
            parent.text = obj.to_s
          end
        end
      end
    end
  end
end
