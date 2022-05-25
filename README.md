# i18n-docs

[![Build Status](https://travis-ci.org/renuo/i18n-docs.svg?branch=master)](https://travis-ci.org/renuo/i18n-docs)
[![Code Climate](https://codeclimate.com/github/renuo/i18n-docs/badges/gpa.svg)](https://codeclimate.com/github/renuo/i18n-docs)
[![Test Coverage](https://codeclimate.com/github/renuo/i18n-docs/badges/coverage.svg)](https://codeclimate.com/github/renuo/i18n-docs/coverage)
[![Issue Count](https://codeclimate.com/github/renuo/i18n-docs/badges/issue_count.svg)](https://codeclimate.com/github/renuo/i18n-docs)
[![Dependency Status](https://gemnasium.com/badges/github.com/renuo/i18n-docs.svg)](https://gemnasium.com/github.com/renuo/i18n-docs)

**i18n-docs** is a ruby gem that helps you to keep translations stored in Google Docs. This makes it easier for translators and project members to coordinate changes and updates. In addition, the standard features of Google Docs are super handy for this process: revision tracking, authorization, publishing, etc.

Although we use it with Google Docs, it could be used with any CSV file.

*this gem is currently in use and tested with Rails 3.1. It probably works with other 3.x versions, but probably not 2.x at the moment.*

## Features

* download translations from multiple Google spreadsheets and store to YAML files
* import/export YAML files with a Google Spreadsheet
* check YAML files for missing translations (`rake i18n:find_missing_keys`)

## Tests

Verify the quality of this gem by checking out this repo and running:

    bundle install
    rake test

## Usage

### Configuration

Add the GEM to your project:

    gem 'i18n-docs'

Create a configuration file in `config/translations.yml`:

    files:
      navigation.yml: "https://docs.google.com/spreadsheet/pub?key=ab43...34f3&single=true&gid=0&output=csv"
      forms.yml: "https://docs.google.com/spreadsheet/pub?key=0Ap...XveWc&single=true&gid=0&output=csv"
      ... etc ...

#### Rails

Finally, let Rails know what locales you will be using. Add this to `config/application.rb`:

    module Web
      class Application < Rails::Application
        # add yml path
        config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*', '*.yml').to_s]
        # locals to support:
        config.i18n.available_locales = [:en,:de,:it,:fr]
      end
    end

This defines which languages and translation files to import from a Google Spreadsheet. The content of the Spreadsheet URL is stored to a file called e.g. `example1.yml` within folders `config/locales/en` and all other detected locales.

#### Non Rails

Load rake tasks in your `Rakefile`:

```ruby
require 'i18n-docs'

spec = Gem::Specification.find_by_name 'i18n-docs'
load "#{spec.gem_dir}/lib/tasks/store_translations.rake"
```

Create `environment` task in your `Rakefile`:

```ruby
task :environment do
  ...
end

```

The minimal scope of this task is to set up `I18n.available_locales`.

Translations will be stored under `config/locales` in project root directory.
Don't forget to setup `I18n` accordingly:

```ruby
I18n.load_path = Dir[File.join(MyProject.root, 'config', 'locales', '**', '*.yml')]
```

And to load them:

```ruby
I18n.backend.load_translations
```

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


## Configuraiton

You can include a set of substitions for preprocessing the CSV after downloading it and before parsing it. Here is an example that replaces non-breaking spaces with normal ones.

    files:
      navigation.yml: "https://docs.google.com/spreadsheet/pub?key=ab43...34f3&single=true&gid=0&output=csv"

    substitutions:
      - from: "\u00A0"
        to: ' '


## Error Handling

I case of the error `OpenSSL::SSL::SSLError: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed` when running `rake i18n:import_translations`
Follow this: http://stackoverflow.com/questions/12562697/opensslsslsslerror-ssl-connect-returned-1-errno-0-state-sslv3-read-server-ce?answertab=active#tab-top

## Todo

*Pull requests welcome!*

* create mocked tests that do not have to download our sample CSV files
* automate the creation of files in config/locales
* automate the detection of which languages are supported
* validate use with rails 2.x, other 3.x versions

## CHANGELOG

### 0.1.0

* usable outside of rails

### 0.0.10

* rename module to be inline with the gem-name
* various cleanups

### 0.0.9

* add version.rb
* content downloaded is forced to UTF-8
* translation keys read are not downcased anymore
* fixes a bug when loading documents with an empty key
* create tmp directory if it does not exist
* strip spaces from keys

### 0.0.7

* YANKED from rubygems.org, sorry

### 0.0.7

* get in sync with Rubygems.org version

### 0.0.4

* update docs, license. Push to Rubygems.org.

### 0.0.3

* open sourced: changed name and description.

### 0.0.2

* removed loading of `awesome_print` from the rake task. It was breaking
  download

### Credits/License

This gem is sponsored by [local.ch](http://www.local.ch/). It is licensed under the [MIT license](http://en.wikipedia.org/wiki/MIT_License). If you're a ruby developer and want to work with us in Switzerland, please check out our [jobs page](http://local-ch.github.com/).
