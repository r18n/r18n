# frozen_string_literal: true

R18n::Filters.add('rails', :rails_custom_filter) do |content, _config, *_params|
  content.gsub('Ruby', 'Rails')
end
