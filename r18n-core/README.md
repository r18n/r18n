# R18n

R18n is an i18n tool to translate your Ruby application into several languages.

Use `r18n-rails` or `sinatra-r18n` to localize Web applications and
`r18n-desktop` to localize desktop application.

## Features

### Ruby-style Syntax

R18n uses hierarchical, not English-centric, YAML format for translations by
default:

```yaml
user:
  edit: Edit user
  name: User name is %1
  count: !!pl
    1: There is 1 user
    n: There are %1 users
```

To access translation you can call methods with the same names:

```ruby
t.user.edit         #=> "Edit user"
t.user.name('John') #=> "User name is John"
t.user.count(5)     #=> "There are 5 users"

t.not.exists | 'default' #=> "default"
t.not.exists.translated? #=> false
```

If the translation key is the name of an Object method you can access it via
hash index:

```ruby
t[:methods] #=> "Methods"
```

### Filters

You can add custom filters for YAML types or any translated string. Filters are
cascading and can communicate with each other.

R18n already has filters for HTML escaping, lambdas, Textile and Markdown:

```yaml
hi: !!markdown |
  **Hi**, people!
greater: !!escape
  1 < 2 is true
```

```ruby
t.hi      #=> "<p><strong>Hi</strong>, people!</p>"
t.greater #=> "1 &lt; 2 is true"
```

### Flexibility

Translation variables and pluralization (“1 comment”, “5 comments”) are filters
too, so you can extend or replace them. For example, you can use the ‘named
variables filter’ from the `r18n-rails-api` gem:

```yaml
greeting: "Hi, %{name}"
```

```ruby
R18n::Filters.on(:named_variables)
t.greeting(name: 'John') #=> "Hi, John"
```

### Flexible Locales

Locales extend the Locale class. For example, English locale extends the time
formatters:

```ruby
l Date.now, :full #=> "30th of November, 2009"
```

Russian has built-in pluralization without any lambdas in YAML:

```
t.user.count(1) #=> "1 пользователь"
t.user.count(2) #=> "2 пользователя"
t.user.count(5) #=> "5 пользователей"
```

### Loaders

R18n can load translations from anywhere, not just from YAML files. You just
need to create loader object with 2 methods: `available` and `load`:

```ruby
class DBLoader
  def available
    Translation.find(:all).map(&:locale)
  end
  def load(locale)
    Translation.find(locale).to_hash
  end
end

R18n.default_places = DBLoader.new
```

You can also set a list of different translation locations or set extension
locations which will be only used with application translation (useful for
plugins).

### Object Translation

You can translate any class, including ORM models (ActiveRecord, DataMapper,
MongoMapper, Mongoid or others):

```
class Product < ActiveRecord::Base
  include R18n::Translated
  # Model has two normal properties: title_en and title_ru
  translations :title
end

# For English users
product.title #=> "Anthrax"

# For Russian users
product.title #=> "Сибирская язва"
```

### Localization

R18n can localize numbers and time:

```
l -5000                 #=> "−5,000"
l Time.now              #=> "30/11/2009 14:36"
l Time.now, :full       #=> "30th of November, 2009 14:37"
l Time.now - 60, :human #=> "1 minute ago"
```

### Several User Languages

If a particular locale is requested but missing, R18n will automatically take
the next available language (according to the browser’s list of locales) and for
cultures with two official languages (e.g., exUSSR) it takes the second language
(e.g., if a translation isn’t available in Kazakh R18n will look for Russian):

```
R18n.set(['kk', 'de'])

i18n.locales    #=> [Locale kk (Қазақша), Locale de (Deutsch),
                #    Locale ru (Русский), Locale en (English)]

i18n.kazakh  #=> "Қазақша", main user language
i18n.deutsch #=> "Deutsch", not in Kazakh, use next user locale
i18n.russian #=> "Русский", not in kk and de, use Kazakh sublocale
i18n.english #=> "English", not in any user locales, use default
```

### Agnostic

R18n has an agnostic core package and plugins with out-of-box support for
Sinatra, Merb and desktop applications.

## Usage

To add i18n support to your app, you can use the particular plugin for your
environment: `r18n-rails`, `sinatra-r18n` or `r18n-desktop`.

If you develop you own plugin or want to use only core gem, you will need to
set default translation places and set current locales by `R18n.set`:

```ruby
R18n.default_places = 'path/to/translations'
R18n.set('en')
```

To set locale only for current thread use `R18n.thread_set`.

You can add helpers to access the current R18n object:

```ruby
include R18n::Helpers

t.yes              #=> "Yes"
l Time.now, :human #=> "now"
r18n.locale.code   #=> "en"
```

### Translation

Translation files are in YAML format by default and have names like
`en.yml` (English) or `en-us.yml` (USA English dialect) with
language/country code (RFC 3066).

In your translation files you can use:

* Strings

    ```yaml
    robot: This is a robot
    percent: "Percent sign (%)"
    ```

* Numbers

    ```yaml
    number: 123
    float: 12.45
    ```

* Pluralizable messages

    ```yaml
    robots: !!pl
      0: No robots
      1: One robot
      n: %1 robots
    ```

* Filters

    ```yaml
    filtered: !!custom_type
      This content will be processed by a filter
    ```

To get the translated string use a method with the key name or square brackets
[] for keys, which is the same with Object methods (`class`, `inspect`, etc):

```ruby
t.robot    #=> "This is a robot"
t[:robot]  #=> "This is a robot"
```

Translation may be hierarchical:

```ruby
t.post.add     #=> "Add post"
t[:post][:add] #=> "Add post"
```

If the locale isn’t found in the user’s requested locale, R18n will search for
it in sublocales or in another locale, which the user also can accept:

```ruby
t.not.in.english #=> "В английском нет"
```

The translated string has a `locale` method for determining its locale (Locale
instance or code string if locale is’t supported in R18n):

```ruby
i18n.not.in.english.locale #=> Locale ru (Русский)
```

You can include parameters in the translated string by specifying arguments:

```yaml
name: My name is %1
```

```ruby
t.name('John') #=> "My name is John"
```

Pluralizable messages get their item count from the first argument:

```ruby
t.robots(0)  #=> "No robots"
t.robots(1)  #=> "One robot"
t.robots(50) #=> "50 robots"
```

If there isn’t a pluralization for a particular number, translation will be use
`n`. If there isn’t a locale file for translation, it will use the English
pluralization rule (`0`, `1` and `n`).

You can check if the key has a translation:

```ruby
t.post.add.translated?   #=> true
t.not.exists.translated? #=> false
```

You can set a default value for untranslated strings:

```ruby
t.not.exists | 'default' #=> "default"
```

You can query the translation keys:

```ruby
t.counties._keys.each do |county|
  puts t.counties[county]
end
```

R18n already has translations for common words for most built in locales.
See `base/` the source.

```ruby
t.yes    #=> "Yes"
t.cancel #=> "Cancel"
t.delete #=> "Delete"
```

### Filters

You can also add you own filters for translations: escape HTML entities, convert
from Markdown syntax, etc. Filters can be passive, only being processed when
loaded.

```yaml
friendship: !!gender
  f: She adds a friend
  m: He adds a friend
```

```ruby
R18n::Filters.add('gender', :user_gender) do |content, config, user|
  if user.female?
    content['f']
  else
    content['m']
  end
end

t.friendship(anne) #=> "She adds a friend"
```

To create a filter you pass the following to `R18n::Filters.add`:

* Filter target. YAML type (`!!type`), `String` for all translations of
  `R18n::Untranslated` for missing translations.
* Optional filter name, to disable, enable or delete it later by
  `R18n::Filters.off`, `R18n::Filters.on` and
  `R18n::Filters.delete`.
* Hash with options:
  * `:passive => true` to filter translations only on load;
  * `:position` within the list of current filters of this type
    (by default a new filter will be inserted into last position).

The filter will receive at least two arguments:
* Translation (possibly already filtered by other filters for this type earlier
  in the list).
* A Hash with translation `locale` and `path`.
* Parameters from translation request will be in the remaining arguments.

#### HTML Escape

R18n contains 2 filters to escape HTML entities: by YAML type and global. If you
need to escape HTML in some translations, just set `!!escape` YAML type:

```yaml
greater: !!escape
  1 < 2 is true
```

```ruby
t.greater #=> "1 &lt; 2 is true"
```

If you develop web application and want to escape HTML in all translations, just
activate the global escape filter:

```ruby
R18n::Filters.on(:global_escape_html)
```

If you enable global HTML escape, you may still use `!!html` YAML type to
disable escaping on some values:

```yaml
warning: !!html
  <b>Warning</b>
```

```ruby
R18n::Filters.on(:global_escape_html)
t.warning #=> "<b>Warning</b>"
```

#### Markdown

To use Markdown in your translations you must install the Maruku gem:

```yaml
hi: !!markdown
  **Hi**, people!
```

```ruby
t.hi #=> "<p><strong>Hi</strong>, people!</p>"
```

#### Textile

To use Textile in your translations you must install the RedCloth gem:

```yaml
alarm: !!textile
  It will delete _all_ users!
```

```ruby
t.alarm #=> "<p>It will delete <em>all</em> users!</p>"
```

#### Lambdas

You can use lambdas in your translations.

```yaml
sum: !!proc |x, y| x + y
```

```ruby
t.sum(1, 2) #=> 3
```

If this is unsafe in your application (for example, user can change
translations), you can disable it:

```ruby
R18n::Filters.off(:procedure)
```

### Localization

You can print numbers and floats according to the rules of the user locale:

```ruby
l -12000.5 #=> "−12,000.5"
```

Number and float formatters will also put real typographic minus and put
non-breakable thin spaces (for locale, which use it as digit separator).

You can translate months and week day names in Time, Date and DateTime by the
`strftime` method:

```ruby
l Time.now, '%B'  #=> "September"
```

R18n has some built-in time formats for locales: `:human`, `:full` and
`:standard` (the default):

```ruby
l Time.now, :human #=> "now"
l Time.now, :full  #=> "August 9th, 2009 21:47"
l Time.now         #=> "08/09/2009 21:41"
l Time.now.to_date #=> "08/09/2009"
```

### Model

You can add i18n support to any classes, including ORM models (ActiveRecord,
DataMapper, MongoMapper, Mongoid or others):

```ruby
class Product
  include DataMapper::Resource
  property :title_ru, String
  property :title_en, String

  include R18n::Translated
  translations :title
end

# For example, user only knows Russian

# Set English (default) title
product.title_en = "Anthrax"
product.title #=> "Anthrax"

# Set value for user locale (Russian)
product.title = "Сибирская язва"
product.title #=> "Сибирская язва"

product.title_en #=> "Anthrax"
product.title_ru #=> "Сибирская язва"
```

See `R18n::Translated` for documentation.

### Locale

All supported locales are stored in R18n gem in `locales` directory. If you want
to add your locale, please fork this project and send a pull request or email me
at <andrey@sitnik.ru>.

To get information about a locale create an `R18n::Locale` instance:

```ruby
locale = R18n::Locale.load('en')
```

You can then get the following from the locale:

* Locale title and RFC 3066 code:

    ```ruby
    locale.title #=> "English"
    locale.code  #=> "en"
    ```

* Language direction (left to right, or right to left for Arabic and Hebrew):

    ```ruby
    locale.ltr? #=> true
    ```

* Week start day (`:monday` or `:sunday`):

    ```ruby
    locale.week_start #=> :sunday
    ```

### Loaders

You can load translations from anywhere, not just from YAML files. To load
translation you must create loader class with 2 methods:

* `available` – return array of locales of available translations;
* `load(locale)` – return Hash of translation.

Pass its instance to `R18n.default_places` or `R18n.set(locales, loaders)`

```ruby
R18n.default_places = MyLoader.new(loader_param)
R18n.set('en')
```

You can set your default loader and pass it to `R18n.set` as the only
constructor argument:

```ruby
R18n.default_loader = MyLoader
R18n.default_places = loader_param

R18n.set('en')
R18n.set('en', different_loader_param)
```

If you want to load a translation with some type for filter, use
`R18n::Typed` struct:

```ruby
# Loader will return something like:
{ 'users' => R18n::Typed.new('pl', { 1 => '1 user', 'n' => '%1 users' }) }

# To use pluralization filter ("pl" type):
t.users(5) #=> "5 users"
```

### Extension Translations

For r18n plugin you can add loaders with translations, which will be used with
application translations. For example, DB plugin may place translations for
error messages in extension directory. R18n contain translations for base words
as extension directory too.

```ruby
R18n.extension_places << R18n::Loader::YAML.new('./error_messages/')
```

## Add Locale

If R18n hasn’t got locale file for your language, please add it. It’s very
simple:

* Create the file <tt><i>code</i>.rb</tt> in the `locales/` directory for your
  language and describe locale. Just copy from another locale and change the
  values.
  * If your country has alternate languages (for example, in exUSSR countries
    most people also know Russian), add
    <tt>sublocales %w{<i>another_locale</i> en}</tt>.
* Create in `base/` file <tt><i>code</i>.yml</tt>  for your language and
  translate the base messages. Just copy file from language, which you know,
  and rewrite values.
* If your language needs some special logic (for example, different
  pluralization or time formatters) you can extend `R18n::Locale` class methods.
* Send a pull request via GitHub <http://github.com/ai/r18n> or just write email
  with the files to me <andrey@sitnik.ru>.

*Code* is RFC 3066 code for your language (for example, “en” for English and
“fr-CA” for Canadian French). Email me with any questions you may have, you will
find other contact addresses at http://sitnik.ru.

## License

R18n is licensed under the GNU Lesser General Public License version 3.
See the LICENSE file or http://www.gnu.org/licenses/lgpl.html.

## Author

Andrey “A.I.” Sitnik <andrey@sitnik.ru>
