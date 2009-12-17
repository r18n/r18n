class TestController < ApplicationController
  def locales
    render :text => R18n.get.locales.map { |i| i.code }.join(', ')
  end
  
  def translations
    render :text => "R18n: #{R18n.get.r18n.translations}. " +
                    "Rails I18n: #{R18n.get.i18n.translations}"
  end
  
  def available
    render :text => R18n.get.available_locales.map { |i| i.code }.join(', ')
  end
  
  def helpers
    @from_controller = r18n.user.name
    render
  end
  
  def untranslated
    render :text => "#{R18n.get.user.not.exists}"
  end
end
