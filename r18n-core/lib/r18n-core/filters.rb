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
  # with filter config as second and filter parameters as next arguments. You
  # can set passive filter, which will process translation only on loading.
  #
  #   R18n::Filters.add('custom_type', :no_space) do |content, config, replace|
  #     content.gsub(' ', replace)
  #   end
  #   R18n::Filters.add('custom_type', :passive => true) do |content, config|
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
  # Hash and you can add you own parameter to cross-filter communications:
  #
  #   R18n::Filters.add(String, :hide_truth) do |content, config|
  #     return content if config[:censorship_check]
  #
  #     if content.scan(CENSORSHIP_WORDS[config[:locale]]).empty?
  #       content
  #     else
  #       "Error in #{config[:path]}"
  #     end
  #   end
  #
  #   R18n::Filters.add('passed', :show_lie) do |content, config|
  #     config[:censorship_check] = true
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
    class << self
      # Hash of filter names to Filters.
      attr_accessor :defined

      # Hash of types to all Filters.
      attr_accessor :by_type

      # Hash of types to enabled active filters.
      attr_accessor :active_enabled

      # Hash of types to enabled passive filters.
      attr_accessor :passive_enabled

      # Hash of types to enabled passive and active filters.
      attr_accessor :enabled

      # Process +value+ by filters in +enabled+.
      def process(enabled, type, value, locale, path, params)
        config = { :locale => locale, :path => path }

        enabled[type].each do |filter|
          value = filter.call(value, config, *params)
        end

        if value.is_a? String
          value = TranslatedString.new(value, locale, path)
          process_string(enabled, value, config, params)
        else
          value
        end
      end

      # Process +value+ by global filters in +enabled+.
      def process_string(enabled, value, config, params)
        if config.is_a? String
          config = { :locale => value.locale, :path => config }
        end
        enabled[String].each do |f|
          value = f.call(value, config, *params)
        end
        value
      end

      # Rebuild +active_enabled+ and +passive_enabled+ for +type+.
      def rebuild_enabled!(type)
        @passive_enabled[type] = []
        @active_enabled[type] = []
        @enabled[type] = []

        @by_type[type].each do |filter|
          if filter.enabled?
            @enabled[type] << filter
            if filter.passive?
              @passive_enabled[type] << filter
            else
              @active_enabled[type] << filter
            end
          end
        end
      end

      # Add new filter for +type+ with +name+ and return filter object. You
      # can use String class as +type+ to add global filter for all translated
      # string.
      # 
      # Filter content will be sent to +block+ as first argument, struct with
      # config as second and filters parameters will be in next arguments.
      # 
      # Options:
      # * +position+ – change order on processing several filters for same type.
      #    Note that passive filters will be always run before active.
      # * +passive+ – if +true+, filter will process only on translation
      #   loading. Note that you must add all passive before load translation.
      def add(types, name = nil, options = {}, &block)
        options, name = name, nil if name.is_a? Hash
        types = Array(types)

        unless name
          @last_auto_name ||= 0
          begin
            @last_auto_name += 1
            name = @last_auto_name
          end while defined.has_key? name
        else
          delete(name)
        end

        filter = Filter.new(name, types, block, true, options[:passive])
        @defined[name] = filter

        types.each do |type|
          @by_type[type] = [] unless @by_type.has_key? type
          if options.has_key? :position
            @by_type[type].insert(options[:position], filter)
          else
            @by_type[type] << filter
          end
          rebuild_enabled! type
        end

        filter
      end

      # Delete +filter+ by name or Filter object.
      def delete(filter)
        filter = @defined[filter] unless filter.is_a? Filter
        return unless filter

        @defined.delete(filter.name)
        filter.types.each do |type|
          @by_type[type].delete(filter)
          rebuild_enabled! type
        end
      end

      # Disable +filter+ by name or Filter object.
      def off(filter)
        filter = @defined[filter] unless filter.is_a? Filter
        return unless filter

        filter.enabled = false
        filter.types.each { |type| rebuild_enabled! type }
      end

      # Turn on disabled +filter+ by name or Filter object.
      def on(filter)
        filter = @defined[filter] unless filter.is_a? Filter
        return unless filter

        filter.enabled = true
        filter.types.each { |type| rebuild_enabled! type }
      end
    end

    Filters.defined         = {}
    Filters.by_type         = Hash.new([])
    Filters.active_enabled  = Hash.new([])
    Filters.passive_enabled = Hash.new([])
    Filters.enabled         = Hash.new([])

    Filter = Struct.new(:name, :types, :block, :enabled, :passive) do
      def call(*params); block.call(*params); end
      def enabled?; enabled; end
      def passive?; passive; end
    end
  end

  Filters.add('proc', :procedure) do |content, config, *params|
    eval("proc { #{content} }").call(*params)
  end

  Filters.add('pl', :pluralization) do |content, config, param|
    param = param.to_i if param.is_a? Float
    if param.is_a? Numeric
      type = config[:locale].pluralize(param)
      type = 'n' if not content.has_key? type
      content[type]
    else
      content
    end
  end

  Filters.add(String, :variables) do |content, config, *params|
    content = content.clone
    params.each_with_index do |param, i|
      content.gsub! "%#{i+1}", config[:locale].localize(param)
    end
    content
  end

  Filters.add(Untranslated, :untranslated) do |v, c, translated, untranslated|
    "#{translated}[#{untranslated}]"
  end

  Filters.add(Untranslated, :untranslated_html) do |v, c, transl, untransl|
    Utils.escape_html(transl) <<
      '<span style="color: red">' << Utils.escape_html(untransl) << '</span>'
  end
  Filters.off(:untranslated_html)

  Filters.add('escape', :escape_html, :passive => true) do |content, config|
    config[:dont_escape_html] = true
    Utils.escape_html(content)
  end

  Filters.add('html', :dont_escape_html, :passive => true) do |content, config|
    config[:dont_escape_html] = true
    content
  end

  Filters.add([String, 'markdown', 'textile'],
              :global_escape_html, :passive => true) do |html, config|
    if config[:dont_escape_html]
      html
    else
      config[:dont_escape_html] = true
      Utils.escape_html(html)
    end
  end
  Filters.off(:global_escape_html)

  Filters.add('markdown', :maruku, :passive => true) do |content, config|
    require 'maruku'
    ::Maruku.new(content).to_html
  end

  Filters.add('textile', :redcloth, :passive => true) do |content, config|
    R18n::Utils.use_syck { require 'redcloth' }
    ::RedCloth.new(content).to_html
  end
end
