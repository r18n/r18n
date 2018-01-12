# frozen_string_literal: true

App::Application.routes.draw do
  get '/locales',      to: 'test#locales'
  get '/translations', to: 'test#translations'
  get '/available',    to: 'test#available'
  get '/helpers',      to: 'test#helpers'
  get '/untranslated', to: 'test#untranslated'
  get '/controller',   to: 'test#controller'
  get '/time',         to: 'test#time'
  get '/human_time',   to: 'test#human_time'
  get '/filter',       to: 'test#filter'
  get '/format',       to: 'test#format'
  get '/safe',         to: 'test#safe'
end
