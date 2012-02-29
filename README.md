# R18n

R18n is an i18n tool to translate your Ruby application into several languages.
It contains a core gem and out-of-box wrapper plugins for frameworks or
environments (Rails, Sinatra, Merb, desktop).

For more feature descriptions and a tutorial see the `r18n-core/` directory.
For special How To see the plugins directory for your environment.

## R18n Features

* Nice Ruby-style syntax.
* Filters.
* Flexible locales.
* Custom translation loaders.
* Translation support for any class.
* Time and number localization.
* Several user languages support.

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
