# encoding: utf-8
require File.expand_path('../spec_helper', __FILE__)

describe R18n::Backend do
  before do
    I18n.load_path = [GENERAL]
    I18n.backend = R18n::Backend.new
    R18n.set('en', R18n::Loader::Rails.new)
  end

  it "should return available locales" do
    I18n.available_locales.should =~ [:en]
  end

  it "should localize objects" do
    time = Time.at(0).utc
    date = Date.parse('1970-01-01')

    I18n.l(time).should == 'Thu, 01 Jan 1970 00:00:00 +0000'
    I18n.l(date).should == '1970-01-01'

    I18n.l(time, :format => :short).should == '01 Jan 00:00'
    I18n.l(time, :format => :full).should == '1st of January, 1970 00:00'

    I18n.l(-5000.5).should == '−5,000.5'
  end

  it "should translate by key and scope" do
    I18n.t('in.another.level').should               == 'Hierarchical'
    I18n.t(:level, :scope => 'in.another').should   == 'Hierarchical'
    I18n.t(:'another.level', :scope => 'in').should == 'Hierarchical'
  end

  it "should use pluralization and variables" do
    I18n.t('users', :count => 0).should == '0 users'
    I18n.t('users', :count => 1).should == '1 user'
    I18n.t('users', :count => 5).should == '5 users'
  end

  it "should use another separator" do
    I18n.t('in/another/level', :separator => '/').should == 'Hierarchical'
  end

  it "should translate array" do
    I18n.t(['in.another.level', 'in.default']).should == ['Hierarchical',
                                                          'Default']
  end

  it "should use default value" do
    I18n.t(:missed, :default => 'Default').should == 'Default'
    I18n.t(:missed, :default => :default, :scope => :in).should == 'Default'
    I18n.t(:missed, :default => [:also_no, :'in.default']).should == 'Default'
  end

  it "should raise error on no translation" do
    lambda {
      I18n.backend.translate(:en, :missed)
    }.should raise_error(::I18n::MissingTranslationData)
    lambda {
      I18n.t(:missed)
    }.should raise_error(::I18n::MissingTranslationData)
  end

  it "should reload translations" do
    lambda { I18n.t(:other) }.should raise_error(::I18n::MissingTranslationData)
    I18n.load_path << OTHER
    I18n.reload!
    I18n.t(:other).should == 'Other'
  end

  it "should return plain classes" do
    I18n.t('in.another.level').class.should == ActiveSupport::SafeBuffer
    I18n.t('in.another').class.should == Hash
  end

  it "should return correct unpluralized hash" do
    I18n.t('users').should == { :one => '1 user', :other => '%{count} users' }
  end

  it "should correct detect untranslated, whem path is deeper than string" do
    lambda {
      I18n.t('in.another.level.deeper')
    }.should raise_error(::I18n::MissingTranslationData)

    lambda {
      I18n.t('in.another.level.go.deeper')
    }.should raise_error(::I18n::MissingTranslationData)
  end

  it "should not call String methods" do
    I18n.t('in.another').class.should == Hash
  end

  it "should not call object methods" do
    lambda {
      I18n.t('in.another.level.to_sym')
    }.should raise_error(::I18n::MissingTranslationData)
  end

  it "should work deeper pluralization" do
    I18n.t('users.other', :count => 5).should == '5 users'
  end

end
