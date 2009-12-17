ActionController::Routing::Routes.draw do |map|
  map.connect ':action', :controller => 'test'
  map.connect ':locale/:action', :controller => 'test'
end
