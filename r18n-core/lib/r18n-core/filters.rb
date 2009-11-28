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

require 'ostruct'
    
module R18n
  # Filter is a way, to process translations: escape HTML entries, convert from
  # Markdown syntax, etc.
  # 
  # In translation file filtered content must be marked by YAML type:
  # 
  #   filtered: !!custom_type
  #     This content will be processed by filter
  # 
  # Filter function will be receive filtered content as first argument, struct
  # with filter config as second and filter parameters as next arguments.
  # 
  #   R18n::Filters.add('custom_type', :no_space) do |content, config, replace|
  #     content.gsub(' ', replace)
  #   end
  #   R18n::Filters.add('custom_type') do |content, config, replace|
  #     content + '!'
  #   end
  #   
  #   i18n.filtered('_') #=> "This_content_will_be_processed_by_filter!"
  # 
  # Use String class as type to add global filter for all translated strings:
  # 
  #   R18n::Filters.add(String, :escape_html) do |content, config, params|
  #     escape_html(content)
  #   end
  #
  # Filter config contain two parameters: translation locale and path. But it is
  # OpenStruct and you can add you own parameter to cross-filter communications:
  # 
  #   R18n::Filters.add(String, :hide_truth) do |content, config|
  #     return content if config.censorship_check
  #     
  #     if content.scan(CENSORSHIP_WORDS[config.locale]).empty?
  #       content
  #     else
  #       "Error in #{config.path}"
  #     end
  #   end
  #   
  #   R18n::Filters.add('passed', :show_lie) do |content, config|
  #     config.censorship_check = true
  #     content
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
      
      # Process +translation+ by global filters and filters for special +type+.
      def process(translation, locale, path, type, params)
        case translation
        when Numeric, NilClass, FalseClass, TrueClass, Symbol
        else
          translation = translation.clone
        end
        config = OpenStruct.new(:locale => locale, :path => path)
        
        if type
          filters = Filters.enabled[type]
          filters.each { |f| translation = f.call(translation, config, *params)}
        end
        
        if translation.is_a? String
          Filters.enabled[String].each do |f|
            translation = f.call(translation, config, *params)
          end
          return TranslatedString.new(translation, locale, path)
        else
          translation
        end
      end
      
      # Add new filter for +type+ with +name+ and return filter object. You
      # can use String class as +type+ to add global filter for all translated
      # string.
      # 
      # Several filters for same type will be call consecutively, but you can
      # set +position+ in call list.
      # 
      # Filter content will be sent to +block+ as first argument, struct with
      # config as second and filters parameters will be in next arguments.
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
  
  Filters.add('proc', :procedure) do |content, config, *params|
    eval("proc { #{content} }").call(*params)
  end
  
  Filters.add('pl', :pluralization) do |content, config, param|
    type = config.locale.pluralize(param)
    type = 'n' if not content.include? type
    content[type]
  end
  
  Filters.add(String, :variables) do |content, config, *params|
    content = content.clone
    params.each_with_index do |param, i|
      if param.is_a? Float
        param = config.locale.format_float(param)
      elsif param.is_a? Integer
        param = config.locale.format_integer(param)
      end
      content.gsub! "%#{i+1}", param.to_s
    end
    content
  end
  
  Filters.add(String, :named_variables) do |content, config, params|
    if params.is_a? Hash
      content = content.clone
      params.each_pair do |name, value|
        if value.is_a? Float
          value = config.locale.format_float(value)
        elsif value.is_a? Integer
          value = config.locale.format_integer(value)
        end
        content.gsub! "{{#{name}}}", value.to_s
      end
    end
    content
  end
  Filters.off(:named_variables)
  
  Filters.add(Untranslated, :untranslated) do |v, c, translated, untranslated|
    "#{translated}[#{untranslated}]"
  end
  
  Filters.add('escape', :escape_html) do |content, config|
    config.dont_escape_html = true
    Utils.escape_html(content)
  end
  
  Filters.add('html', :dont_escape_html) do |content, config|
    config.dont_escape_html = true
    content
  end
  
  Filters.add(String, :global_escape_html) do |content, config|
    if config.dont_escape_html
      content
    else
      Utils.escape_html(content)
    end
  end
  Filters.off(:global_escape_html)
  
  Filters.add('markdown', :maruku) do |content, config|
    require 'maruku'
    ::Maruku.new(content).to_html
  end
  
  Filters.add('textile', :redcloth) do |content, config|
    require 'redcloth'
    ::RedCloth.new(content).to_html
  end
end
