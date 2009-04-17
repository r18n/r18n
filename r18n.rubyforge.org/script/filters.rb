module RubySyntax
  include Haml::Filters::Base
  lazy_require 'syntax/convertors/html'
  
  def render(text)
    Syntax::Convertors::HTML.for_syntax('ruby').convert(text)
  end
end

module YamlSyntax
  include Haml::Filters::Base
  lazy_require 'syntax/convertors/html'
  
  def render(text)
    Syntax::Convertors::HTML.for_syntax('yaml').convert(text)
  end
end

module XmlSyntax
  include Haml::Filters::Base
  lazy_require 'syntax/convertors/html'
  
  def render(text)
    Syntax::Convertors::HTML.for_syntax('xml').convert(text)
  end
end
