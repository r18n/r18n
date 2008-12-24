class I18n < Merb::Controller
  self._template_root = File.dirname(__FILE__) / "../views"

  def index
    @article = i18n.l 10000
    @created = Time.at(0)
    
    render
  end
  
  def code
    render
  end
end
