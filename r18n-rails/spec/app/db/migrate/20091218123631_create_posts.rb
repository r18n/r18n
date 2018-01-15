# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title_en
      t.string :title_ru
    end
  end

  def self.down
    drop_table :posts
  end
end
