# encoding: utf-8
require File.join(File.dirname(__FILE__), '../../lib/sinatra/r18n')
require 'sinatra'

get '/:locale/posts/:name' do
  @post = params[:name]
  erb :post
end

get '/:locale/posts/:name/comments' do
  i18n.post.comments(3).to_s
end

get '/locale' do
  i18n.locale.title
end

get '/locales' do
  i18n.available_locales.map { |i| "#{i.code}: #{i.title}" }.sort.join('; ')
end

get '/greater' do
  i18n.greater
end

get '/warning' do
  i18n.warning
end

get '/untranslated' do
  "#{i18n.post.no}"
end
