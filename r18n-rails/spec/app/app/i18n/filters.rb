R18n::Filters.add('rails', :rails_custom_filter) do |content, config, *params|
  content.gsub('Ruby', 'Rails')
end
