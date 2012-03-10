# encoding: utf-8
require File.join(File.dirname(__FILE__), 'pt')

module R18n::Locales
  class PtBr < Pt
    set :title => 'Português brasileiro',
        :code  => 'pt-BR',
        :sublocales => %w{pt en}
  end
end
