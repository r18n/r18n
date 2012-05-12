class TestController < ApplicationController
  layout false

  def locales
    render :text => R18n.get.locales.map { |i| i.code }.join(', ')
  end

  def translations
    render :text => "R18n: #{R18n.get.r18n.translations}. " +
                    "Rails I18n: #{R18n.get.i18n.translations}"
  end

  def available
    render :text => R18n.get.available_locales.map { |i| i.code }.sort.join(' ')
  end

  def helpers
    @from_controller = r18n.user.name
    render
  end

  def untranslated
    render :text => "#{R18n.get.user.not.exists}"
  end

  def controller
    render :text => "#{t('user.name')}" + "#{t.user.name}" +
                    "#{r18n.t.user.name}"
  end

  def time
    render :text => l(Time.at(0).utc) + "\n" +
                    l(Time.at(0).utc, :format => :short)
  end

  def human_time
    render :text => l(Time.now, :human)
  end

  def filter
    render :text => t.ruby
  end
end
