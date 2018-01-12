# frozen_string_literal: true

class TestController < ApplicationController
  layout false

  before_action :reload_r18n, only: :filter

  def locales
    render plain: R18n.get.locales.map(&:code).join(', ')
  end

  def translations
    render plain: "R18n: #{R18n.get.r18n.translations}. " \
                  "Rails I18n: #{R18n.get.i18n.translations}"
  end

  def available
    render plain: R18n.get.available_locales.map(&:code).sort.join(' ')
  end

  def helpers
    @from_controller = r18n.user.name
    render
  end

  def untranslated
    render plain: R18n.get.user.not.exists.to_s
  end

  def controller
    render plain: "#{t.user.name} #{r18n.t.user.name} #{t('user.name')}"
  end

  def time
    render plain: l(Time.at(0).utc) + "\n" +
                  l(Time.at(0).utc, format: :short)
  end

  def human_time
    render plain: l(Time.now, :human)
  end

  def filter
    render plain: t.ruby
  end

  def format
    render
  end
end
