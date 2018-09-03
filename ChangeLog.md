# Change Log

## 3.1.2 (i)
* Call `Translation#itself` as translation key instead of `Kernel#itself` implementation (by Alexander Popov).

## 3.1.1 (У)
* Fix errors and warnings from `gem build`

## 3.1 (Одинцово)
* Move `named_variables` filter from `r18n-rails-api` to `r18n-core` (by Alexander Popov).
* Add possibility for `R18n::Locale` to define custom formatters (by Alexander Popov).
* Fix `R18n.set` for `r18n-desktop` (by Alexander Popov).

## 3.0.5 (ب)
* Fix Farsi locale name (by @iriman).

## 3.0.4 (𐤀)
* Fix `Translated` compatibility with `Hash` (by Alexander Popov).

## 3.0.3 (〥)
* Fix missed filters in `Untranslted` initialization (by Alexander Popov).

## 3.0.2 (Ё)
* Fix `Untranslted.to_s` (by Patrik Rak).

## 3.0.1 (Brooklyn)
* Fix `no` locale deprecation warning.

## 3.0 (New York)
* Deprecate `no` locale, use `nb` instead (by Alexander Popov).
* Remove unsafe `!!proc` filter.
* Reduce `eval` calls (by Alexander Popov).

## 2.2 (La Habana)
* Change date format in `en` locale to `YYYY-MM-DD` (by Alexander Popov).
* Add `TranslatedString#as_json` for ActiveSupport compatibility (by Tim Craft).
* Fix `TranslatedString#html_safe?` behaviour (by Tim Craft).
* Fix unsupported `LANG` environment (by Chris Poirier).
* Fix `Locale#localize` method for `DateTime` objects (by Alexander Popov).

## 2.1.8 (Ѣ)
* Fix `true` and `false` keys support (by Alexander Popov).

## 2.1.7 (Sewe)
* Add Afrikaans locale (by Llewellyn van der Merwe).

## 2.1.6 (Berlin)
* Better `TranslatedString` → `String` converting (by Patrik Rak).
* Add Ruby on Rails 5 support.

## 2.1.5 (මාතර)
* Fix Ruby 2.4 support (by Alexander Popov)

## 2.1.4 (Bakı)
* Add Azerbaijani locale (by Adil Aliyev).

## 2.1.3 (Seoul)
* Add Korean locale (by Patrick Cheng).

## 2.1.2 (Wien)
* Fix Ruby 2.3 support.

## 2.1.1 (Barcelona)
* Better sanity check for Accept-Language header (by Viktors Rotanovs).

## 2.1 (Một)
* Add Vietnamese locale (by Nguyễn Văn Được).
* Add Persian locale.
* Allow to change date/time order in locales.
* Fix pluralization in locales without plural forms.
* Fix Mongolian base translations.

## 2.0.4 (Ikkuna)
* Fix Windows support (by janahanEDH).

## 2.0.3 (Hévíz)
* Fix Thai locale (by Kasima Tharnpipitchai).

## 2.0.2 (Budapest)
* Fix array support in translations.
* Fix Rails support for dialect locales.

## 2.0.1 (Amsterdam)
* Fix Dutch locale.

## 2.0.0 (Москва)
* Remove Ruby 1.8 and 1.9 support.
* Add JRuby 9000 support.

### 1.1.11 (São Paulo)
* Allow to set Proc as `default` option in Rails I18n backend.

### 1.1.10 (十)
* Fix Esperanto locale by Larry Gilbert.
* Fix Chinese locale (by 刘当一).

### 1.1.9 (Не знайдено)
* Fix Rails 4.0.4 support. Prevent loop on `enforce_available_locales`.

### 1.1.8 (Osam)
* Add Croatian locale (by Dino Kovač).
* Add Serbian latin locale (by Dino Kovač).

### 1.1.7 (Tujuh)
* Return `nil` on untranslated in models with Translated.
* Add `transliterate` method to I18n backend.
* Add Indonesian locale (by Guntur Akhmad).

### 1.1.6 (Vitebsk)
* Return `TranslatedString` after global String filters.
* Fix path in global String filters.

### 1.1.5 (Hilo)
* Fix Sinatra plugin under multithreaded web-server (by Viktors Rotanovs).
* Fix BigDecimal localizing (by François Beausoleil).
* Add American American Spanish locale (by renemarcelo).

### 1.1.4 (Bokmål)
* Add Norwegian “no” locale as gateway to Bokmål or Nynorsk.
* Fix Norwegian Bokmål locale code.
* Fix hungarian time format (Kővágó Zoltán).

### 1.1.3 (Saint Petersburg)
* Fix memory leak from cache key missmatch in Rails plugin (by silentshade).

### 1.1.2 (Marshal)
* Fix translation and untranslated marshalizing (by silentshade).
* Allow to compare untranslated strings.
* Fix untranslated strings output in tests.

### 1.1.1 (Dunhuang)
* Don’t change YAML parser in Ruby 1.9.
* Allow to change locale by argument in R18n Rails backend.
* Set also Rails I18n locale in Rails autodetect filter.
* Fix caching with custom filters (by Anton Onyshchenko).
* Fix translation variables with `%1` text inside (by Taras Kunch).
* Fix Latvian locale (by Aleksandrs Ļedovskis).

### 1.1.0 (Leipzig)
* A lot of fixes in Rails I18n compatibility (thanks for Stephan Schubert).
* Return Untranslted, when user try to call another translation key on
  already translated string.
* Add `Translation#to_hash` to get raw translation.
* Add `Translation#inspect` to easy debug.
* Return translation, when pluralization filter didn’t get count.
* Set R18n backend on Rails plugin init, to use it in console.
* Allow to use Integer in translation keys.

### 1.0.1 (Phuket Town)
* Fix translation reloading in Rails and Sinatra.
* Use global R18n settings for Sinatra extension.
* Allow to override desktop autodetect by LANG environment on all platforms.
* Add support for JRuby in 1.9 mode.
* Rename `R18n.reset` to `R18n.reset!` and add `R18n.clear_cache!`.
* Fix Sinatra with loaded ActiveSupport.
* Add Mongolian locale (by Elias Klughammer).

### 1.0.0 (Bangkok)
* Add `R18n.default_places`.
* Rails SafeBuffer support.
* Allow in Rails app to put filters to `app/i18n` reload them in development.
* Move `R18n::I18n.available_locales` to `R18n.available_locales`.
* Rename `_keys` to `translation_keys`.
* Use Kramdown instead of Maruku for Markdown.
* Allow to use R18n for Rails without mailer.
* Allow to overwrite I18n object for models.
* Autoload R18n::Translated.
* Set default locale to R18n on Rails start to easy use in Rails console.
* Use env language in Rails console.
* Mark untranslated part as red in Rails console.
* Allow to temporary change locale by `R18n.change`.
* Add `R18n.locale` shortcut.
* Allow return from setter block locale code, instead of I18n object.
* Allow to set custom filters for I18n object.
* Add Galician locale (by Eduard Giménez).
* Add Traditional Chinese and Simplified Chinese (by Francis Chong).
* Fix Norsk locale (by Peter Haza).

### 0.4.14 (üç)
* Fix support for Ruby 1.9.3.
* Added Turkish locale (by Ahmet Özkaya).
* Fix Swedish locale (by Pär Wieslander).

### 0.4.13 (Sti)
* Fix Pathname to String error in r18n-desktop.
* Add Norwegian locale (by Oddmund Strømme).

### 0.4.12 (Шлях)
* Fix Pathname to String convertion error.
* Fix model translation for non-ActiveRecord (by Szymon Przybył).
* Add Ukrainian locale (by Ярослав Руденок).

### 0.4.11 (Nancy)
* Support for Sinatra 1.3.
* Fix JRuby support by Paul Walker.
* Add R18n helpers to Rails mailer by Alexey Medvedev.

### 0.4.10 (Kvantum)
* Add R18n.set(locales, places), R18n.t and R18n.l shortcuts.
* Convert float to number on pluralization.
* Fix loading empty translation file.
* Add Portuguese locale.
* Add Dutch locale (by Sander Heilbron).
* Add Swedish locale (by Magnus Hörberg).

### 0.4.9 (Kazan)
* Add support for Psych YAML parser (thanks for Ravil Bayramgalin).
* Fix ActiveRecord support in Translated.
* Fix Translated to return non-string values.
* Fix human time localization.
* Add Bulgarian locale (by Mitko Kostov).
* Add Australian English locale (by Dave Sag).

### 0.4.8 (En ni to)
* Fix support for Ruby 1.9.2.
* Fix caching issue (by Viktors Rotanovs).
* Add Danish locale (by Hans Czajkowski Jørgensen)
* Fix Italian locale (by Viktors Rotanovs).
* Move untranslated filters with html highlight to r18n-core.

### 0.4.7.1 (Kyū)
* Fix Japanese locale in Ruby 1.9.1.

### 0.4.7 (Mado)
* Fix autodetect locale in Windows and Ruby 1.9.1 (by Marvin Gülker).
* Fix autodetect locale in JRuby (by Kővágó, Zoltán).
* Fix human time format on 60 minutes.
* Add Hungarian locale (by Kővágó, Zoltán).
* Add Japanese locale (by hryk).
* Fix Polish locale (by Piotr Szotkowski).

### 0.4.6 (Trinity)
* Add support for new interpolation syntax in Rails 3.
* Add Catalian locale (by Jordi Romero).
* Add Finish locale (by Laura Guillén).
* Add British locale (by JP Hastings-Spital).
* Add Latvian locale (by Iļja Ketris).
* Fix Spanish (by Jordi Romero), German, French, Esperanto (by Iļja Ketris) and
  Polish locales.
* Fix documentation (by Iļja Ketris and felix).
* Remove RubyGems from plugins requires.

### 0.4.5 (Annual)
* Filters for several types.
* Global HTML escaping run before Markdown and Textile formatting.
* Fix active filters after passive filters.
* Fix human time formatting for dates with same month days.

### 0.4.4 (Frank)
* Use before filter to lazy set I18n object in Sinatra extension.
* Set I18n object to thread (by Simon Hafner).
* Add to l Rails helper R18n syntax.
* Add common helpers.
* Clear cache in R18n.reset.
* Clean up code and fix bug (by Akzhan Abdulin).
* Add Thai locale (by Felix Hanley).

### 0.4.3 (Flange)
* Add R18n style methods to Rails controllers.
* Fix for non-string translations in Rails I18n.
* Use default locale from Rails I18n config.
* Load translations recursively.
* Add Slovak locale (by Ahmed Al Hafoudh)

### 0.4.2 (EMS)
* Fixes for Ruby 1.8.6 (by Akzhan Abdulin).
* Add method to get translation keys.

### 0.4.1 (Lazy Boole)
* Add passive filters.
* Receive filter position as option Hash.
* Fix base translations (by Pavel Kunc).

### 0.4 (D-Day)
* Rails I18n compatibility.
* Rewrite a lot of core code to fast and cleanup version.
* Custom translation loaders.
* Add reload! method to I18n.
* Add t and l helpers to Sinatra and desktop plugins.
* Syntax sugar for default values.
* Named variables.
* New locale API.
* Change API for extension translations.

### 0.3.2 (Pidgin)
* Print path of untranslated string by filters.
* Add Italian locale (by Guido De Rosa).
* Fix Polish locale (by Adrian Pacała).
* Fix American English locale (by Max Aller).

### 0.3.1 (Yield)
* Add Chinese locale (by Ilia Zayats).
* Add Spanish locale (by Andre O Moura).
* Add Brazilian Portuguese locale (by Andre O Moura).
* Remove RubyGems requires.

### 0.3 (Vladivostok)
* Translated mixin to add i18n support to model or any other class.
* New cool time formatters.
* Filters for translations.
* Add filters to escape HTML, Markdown and Textile syntax.
* Pluralization and variables is now filters and can be replaced.
* I18n#locales now contain all detected locales, used to load translations,
  instead of just received from user.
* Bugfix in locale code case.
* Add Czech locale (by Josef Pospíšil).

### 0.2.3 (Shanghai eclipse)
* R18n will return path string if translation isn’t exists.
* Add UnsupportedLocale class for locale without information file.
* Load absent locale information from default locale.
* Add Polish locale (by Tymon Tobolski).

### 0.2.2 (Clone Wars)
* Localize numbers in pluralization.
* Bugfix in translation variables.

### 0.2.1 (Neun)
* Ruby 1.9 compatibility.
* Add German locale (by Benjamin Meichsner).

### 0.2 (Freedom of Language)
* Locale class can be extended for special language (for example, Indian locale
  may has another digits grouping).
* Load translations from several dirs.
* Add French locale.
* Add Kazakh locale.

### 0.1.1 (Saluto)
* Loading i18n object without translations.
* Add output for standalone month name.
* Don’t call procedures from translations if it isn’t secure.
* Add Esperanto locale.
* English locale now contain UK date standards.
