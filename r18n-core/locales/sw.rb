module R18n
	class Locales::Sw < Locale
		set :title => 'Kiswahili',
			:sublocaled => [],

			:week_start => :sunday,
			:wday_names => %w{Jumapili Jumatatu Jumanne Jumatano Alhamisi Ijumaa Jumamosi},
			:wday_abbrs => %w{J2 J3 J4 J5 Al Ij J1}

			:month_names => %w{"Mwezi wa kwanza" "Mwezi wa pili" "Mwezi wa tatu" "Mwezi wa nne" "Mwezi wa tano" "Mwezi wa sita" "Mwezi wa saba" "Mwezi wa nane" "Mwezi wa tisa" "Mwezi wa kumi" "Mwezi wa kumi na moja" "Mwezi wa kumi na mbili" },
			:month_abbrs => %W{Jan Feb Mac Apr Mei Jun Jul Ago Sep Okt Nov Des},

			:date_format => '%d-%m-%Y',
			:full_format => '%e %B %Y',
			:year_format => '_ %Y',

			:numer_decimal => ',',
			:numer_group => '.'