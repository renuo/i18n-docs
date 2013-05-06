# i18n-docs

**i18n-docs** is a ruby gem that helps you to keep translations stored in Google Docs. This makes it easier for translators and project members to coordinate changes and updates. In addition, the standard features of Google Docs are super handy for this process: revision tracking, authorization, publishing, etc.

Although we use it with Google Docs, it could be used with any CSV file.

*this gem is currently in use and tested with Rails 3.1. It probably works with other 3.x versions, but probably not 2.x at the moment.*

## Features:

* download translations from multiple Google spreadsheets and store to YAML files
* import/export YAML files with a Google Spreadsheet
* check YAML files for missing translations (`rake i18n:find_missing_keys`)

## Usage

### Configuration

Add the GEM to your Rails project:

    gem 'i18n-docs'

Create a configuration file in `config/translations.yml`:

    files:
      navigation.yml: "https://docs.google.com/spreadsheet/pub?key=ab43...34f3&single=true&gid=0&output=csv"
      forms.yml: "https://docs.google.com/spreadsheet/pub?key=0Ap...XveWc&single=true&gid=0&output=csv"
      ... etc ...

Finally, let Rails know what locales you will be using. Add this to `config/application.rb`:

    # locals to support:
    I18n.available_locales = [:en,:de,:it,:fr]

This defines which languages and translation files to import from a Google Spreadsheet. The content of the Spreadsheet URL is stored to a file called e.g. `example1.yml` within folders `config/locales/en` and all other detected locales.

### Rake Tasks

Following Rake tasks are added by the GEM to your Rails project:

* `rake i18n:export_translations`
  Export all language files to CSV files (ENV 'locale' have to set for non-'en' locales else only files contained in 'en' folder are considered)
* `rake i18n:import_translations`
  Download translations from Google Spreadsheet and save them to YAML files.
* `rake i18n:missing_keys`
  Find and list translation keys that do not exist in all locales


## Setup at Google Docs

* At Google Docs, create a new spreadsheet for your translations. The first column is the translation key, the other columns are the languages:
![screenshot](http://dl.dropbox.com/u/385855/Screenshots/bamr.png)
* use option `File -> Publish To the Web`
![screenshot](http://dl.dropbox.com/u/385855/Screenshots/2-lp.png)
* use **get a link** to generate a unique url that points to the CSV spreadsheet
![screenshot](http://dl.dropbox.com/u/385855/Screenshots/oom_.png)
* From now on you should only update translations in Google Docs and run `rake i18n:import_translations` in the application to get changes. You can also export your

## Todo

*Pull requests welcome!*

* create mocked tests that do not have to download our sample CSV files
* automate the creation of files in config/locales
* automate the detection of which languages are supported
* validate use with rails 2.x, other 3.x versions

## CHANGELOG

### 0.0.4

Update docs, license. Push to Rubygems.org.

### 0.0.3

* Open sourced: changed name and description.

### 0.0.2

* removed loading of `awesome_print` from the rake task. It was breaking
  download

### Credits/License

This gem is sponsored by [local.ch](http://www.local.ch/). It is licensed under the [MIT license](http://en.wikipedia.org/wiki/MIT_License). If you're a ruby developer and want to work with us in Switzerland, please check out our [jobs page](http://local-ch.github.com/).

