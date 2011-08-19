class Post < ActiveRecord::Base
  include R18n::Translated
  translations :title
end
