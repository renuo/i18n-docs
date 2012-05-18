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
      pre_signup.yml: "https://docs.google.com/spreadsheet/pub?key=ab43...34f3&single=true&gid=0&output=csv"
      navigation.yml: "https://docs.google.com/spreadsheet/pub?key=0Ap...XveWc&single=true&gid=0&output=csv"
      ... etc ...

Make the directories and files to hold the translations:

```
$ rails g i18n_docs:locales da se no
      create  config/locales/da/your_combination.yml.yml
      create  config/locales/da/pre_signup.yml.yml
      create  config/locales/da/navigation.yml.yml
      create  config/locales/da/extras.yml.yml
      create  config/locales/da/your_team.yml.yml
      create  config/locales/se/your_combination.yml.yml
      create  config/locales/se/pre_signup.yml.yml
      create  config/locales/se/navigation.yml.yml
      create  config/locales/se/extras.yml.yml
      create  config/locales/se/your_team.yml.yml
      create  config/locales/no/your_combination.yml.yml
      create  config/locales/no/pre_signup.yml.yml
      create  config/locales/no/navigation.yml.yml
      create  config/locales/no/extras.yml.yml
      create  config/locales/no/your_team.yml.yml
```
      
Finally, let Rails know what locales you will be using. Add this to `config/application.rb`:

    # locales to support:
    I18n.available_locales = [:en,:de,:it,:fr]

This defines which languages and translation files to import from a Google Spreadsheet. The content of the Spreadsheet URL is stored to a file called e.g. `example1.yml` within folders `config/locales/en` and all other detected locales.

## Generators

## Translation APIs

The built in (optional) auto-translation currently only supports Google Translation API.

Please help us add Bing or some other translation API support :)

### Normalizer

Normalizes yml files, converting tabs to 2 spaces pr. default
This is useful before export in order to better ensure that yaml files have valid syntax.

`$ rails g i18n_docs:normalize da`

By default, the normalized files are prefixed with '_'. In order to overwrite existing files, use the overwrite option.

`$ rails g i18n_docs:normalize da --overwrite true`

In addition you can use the space option to customize spaces pr tab.

`$ rails g i18n_docs:normalize da se --spaces 4`

If you want to clean up and remove the normalized files, use the delete option

`$ rails g i18n_docs:normalize da se --delete`

If you want to accept all normalized files prefixed with '_'

`$ rails g i18n_docs:normalize da se --accept`

## Copy master

Use one locale as master and copy into other locales while changing the root key :) 

`$ rails g i18n_docs:copy_master da --into se no`

Auto translate from the master locale file to each locale generated. 

`$ rails g i18n_docs:copy_master da --into sv --auto-translate`

### Export

Export locale files as CSV files to upload to Google Docs

`$ rails g i18n_docs:export`

Use specific (here danish) locale as the master locale

`$ rails g i18n_docs:export da`

Auto translate from the master locale file to each csv generated. 

`$ rails g i18n_docs:export da --auto-translate`

It also supports a locales option to control for which locales to export.
The normalize option can be used to pre-normalize before export using the normalize generator.

`$ rails g i18n_docs:export da --locales sv --auto-translate --normalize`

Finally the outpur-dir option can be used to control where to export the cvs files. If you use the ~ (HOME alias) it will substitute with ENV['HOME'] and work as expected ;)

`$ rails g i18n_docs:export da --locales sv --output-dir "~/Documents/csv"`

### Find missing keys

Find and list translation keys that do not exist in all locales

`$ rails g i18n_docs:missing_keys`

### Import

Import csv files from Google Docs as locale files

`$ rails g i18n_docs:import`

### Rake Tasks

Following Rake tasks are added by the GEM to your Rails project:

* `rake i18n:export_translations`
  Export all language files to CSV files (only files contained in 'en' folder are considered)
* `rake i18n:export_translations[da]` (override default: only files in 'da' folder)

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

* Create mocked tests that do not have to download our sample CSV files
* Support more Translation APIs besides Google, fx Bing etc.

## CHANGELOG

See CHANGELOG file

### Credits/License

This gem is sponsored by [local.ch](http://www.local.ch/). It is licensed under the [MIT license](http://en.wikipedia.org/wiki/MIT_License). If you're a ruby developer and want to work with us in Switzerland, please check out our [jobs page](http://local-ch.github.com/).

