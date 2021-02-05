# frozen_string_literal: true

class Post < ApplicationRecord
  include R18n::Translated
  translations :title
end
