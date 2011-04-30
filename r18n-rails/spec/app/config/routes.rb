App::Application.routes.draw do
  controller :test do
    match '/:action', :via => 'get'
    match '/:locale/:action', :via => 'get'
  end
end
