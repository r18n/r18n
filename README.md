# R18n

R18n is an i18n tool to translate your Ruby application into several languages.
It contains a core gem and out-of-box wrapper plugins for frameworks or
environments (Rails, Sinatra, Merb, desktop).

For more feature descriptions and a tutorial see the `r18n-core/` directory.
For special How To see the plugins directory for your environment.

## Quick Demo

`i18n/en.yml`:

```yaml
user:
  edit: Edit user
  name: User name is %1
  count: !!pl
    1: There is 1 user
    n: There are %1 users
```

`example.rb`:

```ruby
# Setup R18n (or just use out-of-box `r18n-rails` or `sinatra-r18n` gem)
R18n.default_places = './i18n/'
R18n.set('en')

include R18n::Helpers

# Use R18n
t.user.edit         #=> "Edit user"
t.user.name('John') #=> "User name is John"
t.user.count(5)     #=> "There are 5 users"

t.not.exists | 'default' #=> "default"
t.not.exists.translated? #=> false

l Time.now         #=> "03/01/2010 18:54"
l Time.now, :human #=> "now"
l Time.now, :full  #=> "3rd of January, 2010 18:54"
```

## R18n Features

* Nice Ruby-style syntax.
* Filters.
* Model Translation (or any Ruby object).
* Autodetect user locales.
* Flexible locales.
* Total flexibility.

### Ruby-style Syntax

You can use more compact, explicit and ruby-style syntax.

R18n for translations uses compact YAML with types:

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
hash index or use Rails I18n API in `r18n-rails`:

```ruby
t[:methods] #=> "Methods"
```

If you use `r18n-rails` plugin, you will have full compatibility for Rails I18n
syntax.

### Filters

You can add filters for some YAML type. For example, we add custom filter to
return different translation depend on user gender (it’s actual for some languages).

```yaml
log:
  signup: !!gender
    male: Он зарегистрировался
    female: Она зарегистрировалась
```

```ruby
R18n::Filters.add(:gender) do |translation, config, user|
  translation[user.gender]
end

t.log.signup(user)
```

R18n already has filters for HTML escaping, Textile, Markdown and lambdas:

```yaml
hi: !!markdown
  **Hi**, people!
greater: !!escape
  1 < 2 is true
```

```ruby
i18n.hi      #=> "<p><strong>Hi</strong>, people!</p>"
i18n.greater #=> "1 &lt; 2 is true"
```

You can also add filters for all returned translations or to issues, when
translation can’t be founded.

### Model Translation

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

### Autodetect User Locales
R18n has an agnostic core package and plugins with standard support for
Sinatra and desktop applications. So you common cases you can use out-of-box
gems with user locale autodetect. For special cases you can use core gem and
hack everything, that you want (see “Total flexibility” section).

R18n automatically generate fallbacks for current user, based on
user locales list from `HTTP_ACCEPT_LANGUAGE`, locale info (in some countries
people know several languages), and default locale. For example, if user know
Kazakh and German, R18n will try find translations in: Kazakh → German →
Russian (second language in Kazakhstan) → English (default locale).

### Flexible locales

R18n store separated business translations and locale information. So all 
locales (pluralization rules, time and number localization,
some base translations) ship with core gem and can be used out-of-box:

For example, Russian has built-in pluralization without any lambdas in YAML:

```
t.user.count(1) #=> "1 пользователь"
t.user.count(2) #=> "2 пользователя"
t.user.count(5) #=> "5 пользователей"
```

Locales are simple Ruby classes, so they can be very flexible. For example,
R18n ship with very perfection `full` time formatter:

```ruby
R18n.set('en') # English
l Time.now, :full         #=> "1st of December, 2011 12:00"
l Time.now + 1.day, :full #=> "2nd of December, 2011 12:00"

R18n.set('fr') # French
l Time.now, :full         #=> "1er décembre 2011 12:00"
l Time.now + 1.day, :full #=> "2 décembre 2011 12:00"
```

Years in Thailand are now counted in the Buddhist Era. It’s very easy for R18n:

```ruby
R18n.set('th')
R18n.l Time.now, :full #=> "1 พฤศจิกายน, 2554 12:00"
```

### Total flexibility

R18n is very flexible and agnostic. For example, Rails I18n compatibility level
is just few filters and custom loader.

Translation variables and pluralization (“1 comment”, “5 comments”) are filters
too, so you can disable, replace or cascade them. For example, you can use the
“named variables filter” from the `r18n-rails-api` gem:

```yaml
greeting: "Hi, %{name}"
```

```ruby
R18n::Filters.on(:named_variables)
t.greeting(name: 'John') #=> "Hi, John"
```

Or you can add cascade filter on all untranslated messages to collect issues:

```ruby
R18n::Filters.add(::R18n::Untranslated) do |v, c, transl, untransl, path|
  File.open('untranslated.list', 'w') { |io| io.puts(path) }
end
```

R18n can load translations from anywhere, not just from YAML files. You just
need to create loader object with 2 methods: `available` and `load`:

```ruby
class DBLoader
  def available
    Translation.all.map(&:locale)
  end
  def load(locale)
    Translation.find_by_locale(locale).to_hash
  end
end

R18n.default_places = DBLoader.new
R18n.set('en') # Load English messages from DB
```

Also you can use several I18n object in program. For example, to communicate
with user and log system journal for admins:

```ruby
puts I18n.t :error # Show error in French

admin_i18n = R18n::I18n.new(ADMIN_LOCALES)
logger.debug(admin_i18n.errors[error])
```
