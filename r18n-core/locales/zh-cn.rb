require File.join(File.dirname(__FILE__), 'zh')

module R18n::Locales
  class ZhCn < Zh
    set title: '简体中文',
        sublocales: %w{zh en}
  end
end
