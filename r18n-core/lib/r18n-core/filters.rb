# encoding: utf-8
=begin
Filters for translations content.

Copyright (C) 2009 Andrey “A.I.” Sitnik <andrey@sitnik.ru>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
=end

module R18n
  # Filter is a way, to process translations: escape HTML entries, convert from
  # Markdown syntax, etc.
  # 
  # In translation file filtered content must be marked by YAML type:
  # 
  #   filtered: !!custom_type
  #     This content will be processed by filter
  # 
  # Filter function will be receive filtered content as first argument, current
  # locale as second and filter parameters as next arguments.
  # *Warning*: Don’t change content in filters, only return changed copy (use
  # +gsub+ instead <tt>gsub!</tt>, etc).
  # 
  #   R18n::Filters.add('custom_type', :no_space) do |content, locale, replace|
  #     content.gsub(' ', replace)
  #   end
  #   R18n::Filters.add('custom_type') do |content, locale, replace|
  #     content + '!'
  #   end
  #   
  #   i18n.filtered('_') #=> "This_content_will_be_processed_by_filter!"
  # 
  # Use String class as type to add global filter for all translated strings:
  # 
  #   R18n::Filters.add(String, :escape_html) do |content, locale, params|
  #     escape_html(content)
  #   end
  # 
  # You can disable, enabled and delete filters:
  # 
  #   R18n::Filters.off(:no_space))
  #   i18n.filtered('_') #=> "This content will be processed by filter!"
  #   R18n::Filters.on(:no_space)
  #   i18n.filtered('_') #=> "This_content_will_be_processed_by_filter!"
  #   R18n::Filters.delete(:no_space)
  module Filters
    Filter = Struct.new(:name, :type, :block, :enabled) do
      def call(*params)
        block.call(*params)
      end
      
      def enabled?
        enabled
      end
    end
    
    class << self
      # Hash of filter names to Filters.
      def defined
        @defined ||= {}
      end
      
      # Hash of types to enabled Filters.
      def enabled
        @enabled ||= Hash.new([])
      end
      
      # Hash of types to all Filters.
      def by_type
        @by_type ||= Hash.new([])
      end
      
      # Add new filter for +type+ with +name+ and return filter object. You
      # can use String class as +type+ to add global filter for all translated
      # string.
      # 
      # Several filters for same type will be call consecutively, but you can
      # set +position+ in call list.
      # 
      # Filter content will be sent to +block+ as first argument, locale as
      # second and filters parameters will be in next arguments.
      def add(type, name = nil, position = nil, &block)
        unless name
          @last_auto_name ||= 0
          begin
            @last_auto_name += 1
            name = @last_auto_name
          end while defined.has_key? name
        else
          delete(name)
        end
        
        filter = Filter.new(name, type, block, true)
        defined[name] = filter
        
        unless enabled.has_key? type
          enabled[type] = []
          by_type[type] = []
        end
        if position
          enabled[type].insert(position, filter)
          by_type[type].insert(position, filter)
        else
          enabled[type] << filter
          by_type[type] << defined[name]
        end
        
        filter
      end
      
      # Delete +filter+ by name or Filter object.
      def delete(filter)
        filter = defined[filter] unless filter.is_a? Filter
        return unless filter
        
        defined.delete(filter.name)
        by_type[filter.type].delete(filter)
        enabled[filter.type].delete(filter)
      end
      
      # Disable +filter+ by name or Filter object.
      def off(filter)
        filter = defined[filter] unless filter.is_a? Filter
        return unless filter
        
        filter.enabled = false
        enabled[filter.type].delete(filter)
      end
      
      # Turn on disabled +filter+ by name or Filter object.
      def on(filter)
        filter = defined[filter] unless filter.is_a? Filter
        return unless filter
        
        filter.enabled = true
        enabled[filter.type] = by_type[filter.type].reject { |i| !i.enabled? }
      end
    end
  end
  
  Filters.add('proc', :procedure) do |content, locale, *params|
    eval("proc { #{content} }").call(*params)
  end
  
  Filters.add('pl', :pluralization) do |content, locale, param|
    type = locale.pluralize(param)
    type = 'n' if not content.include? type
    content[type]
  end
  
  Filters.add(String, :variables) do |content, locale, *params|
    content = content.clone
    params.each_with_index do |param, i|
      if param.is_a? Float
        param = locale.format_float(param)
      elsif param.is_a? Integer
        param = locale.format_integer(param)
      end
      content.gsub! "%#{i+1}", param.to_s
    end
    content
  end
end
