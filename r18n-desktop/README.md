# R18n Desktop

A tool to translate your desktop application to several languages.

It is just a wrapper for R18n core library. See R18n documentation for more
information.

## Features

* Nice Ruby-style syntax.
* Filters.
* Model Translation (or any Ruby object).
* Autodetect user locales.
* Flexible locales.
* Total flexibility.

See full features in [main README](https://github.com/r18n/r18n/blob/master/README.md).

## How To

1. Create translations dir. For example: `./i18n/`.
2. Add file with translation to `./i18n/` with language code in file name
   (for example, `en.yml` for English or `en-us.yml` USA English dialect).
   For example, `./i18n/en.yml`:

     ```yaml
    file:
      add: Add file
      delete: Delete file %1

    files: !!pl
      0: No files
      1: One file
      n: '%1 files'
     ```

3. Add R18n to your application:

     ```ruby
    require 'r18n-desktop'
     ```

4. Load I18n object:

     ```ruby
    R18n.from_env('i18n/')
     ```
   User can set the locale manually:

     ```ruby
    R18n.from_env('i18n/', manual_locale)
     ```

5. Include mixin to use helpers:

     ```ruby
    include R18n::Helpers
     ```

6. Use translation messages to user. For example:

     ```ruby
    t.file.add            #=> "Add file"
    t.file.delete('Test') #=> "Delete file Test"
    t.files(1)            #=> "One file"
    t.files(12)           #=> "12 files"

    l -12000.5          #=> "−12,000.5"
    l Time.now          #=> "2009-08-09 21:41"
    l Time.now, :human  #=> "now"
    l Time.now, :full   #=> "August 9th, 2009 21:41"

    # Base translation
    t.ok     #=> "OK"
    t.cancel #=> "Cancel"
     ```

7. You can print user locale or available locales:

     ```ruby
    "Your locale: " + r18n.locale.title
    "Select another: " + r18n.available_locales.map { |i| i.title }.join(', ')
     ```

## License

R18n is licensed under the GNU Lesser General Public License version 3.
You can read it in LICENSE file or in http://www.gnu.org/licenses/lgpl.html.

## Author

Andrey “A.I.” Sitnik <andrey@sitnik.ru>
