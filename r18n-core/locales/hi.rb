# Borrowed from Rajesh Ranjan (rajesh672@gmail.com)
# At https://gist.github.com/rajesh672/11338b8acab7482f43e0

require File.join(File.dirname(__FILE__), 'hi')

module R18n::Locales
  class Locales::Hi < Locale
    set title: 'हिन्दी भाषा',
        wday_names: %w{रविवार, सोमवार, मंगलवार, बुधवार, गुरुवार, शुक्रवार, शनिवार},
        wday_abbrs: %w{रवि, सोम, मंगल, बुध, गुरु, शुक्र, शनि},

        month_names:      %w{जनवरी, फरवरी, मार्च, अप्रैल, मई, जून, जुलाई, अगस्त, सितंबर, अक्टूबर, नवंबर, दिसंबर},
        month_abbrs:      %w{जन, फर, मार्च, अप्रै, मई, जून, जुला, अग, सितं, अक्टू, नवं, दिस},
        date_format: '%d-%m-%Y',

        number_decimal: '.',
        number_group:   ','
  end
end
