# encoding: utf-8
require 'sinatra'

get '/:locale/posts/:name' do
  @post = params[:name]
  erb :post
end

get '/:locale/posts/:name/comments' do
  i18n.post.comments(3).to_s
end

get '/locale' do
  i18n.locale['title']
end

get '/locales' do
  i18n.translations.map { |i| i.join(': ') }.sort.join('; ')
end
