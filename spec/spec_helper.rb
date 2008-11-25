require File.join(File.dirname(__FILE__), '../lib/r18n-core')

class FakeIndianLocale < R18n::Locale
  def initialize
    super('en')
    @locale['numbers'] = {
      'separation' => 'indian',
      'decimal_separator' => '.',
      'group_delimiter' => ','
    }
  end
end

DIR = Pathname(__FILE__).dirname + 'translations/general'
TWO = Pathname(__FILE__).dirname + 'translations/two'
EXT = Pathname(__FILE__).dirname + 'translations/extension'
