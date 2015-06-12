# i18n-docs

**i18n-docs** is a ruby gem that helps you to keep translations stored in Google Docs. This makes it easier for translators and project members to coordinate changes and updates. In addition, the standard features of Google Docs are super handy for this process: revision tracking, authorization, publishing, etc.

Although we use it with Google Docs, it could be used with any CSV file.

This gem works as well outside of a Rails environment. You can call it any ruby file.

*this gem is currently in use and tested with Rails 3.1. It probably works with other 3.x versions, but probably not 2.x at the moment.*

## Features:

* download translations from multiple Google spreadsheets and store to YAML files
* import/export YAML files with a Google Spreadsheet

## Usage

### Configuration

Create a configuration file called `translations.yml` and list the files you want to pull from:

    files:
      navigation.yml: "google-drive|1GsKs4bbw4...DJSvt_Cjwfw|navigation"
      forms.yml: "google-drive|1GsKs4bbw4...DJSvt_Cjwfw|forms"
      standard.yml : "config/locales/standards.yml"
      ... etc ...

Note that the Google Doc spreadsheet is identified by its key (see its url https://docs.google.com/spreadsheets/d/{google_doc_key}/edit) and a sheet
Note that you can pull information from some local files by giving directly an url from where the gem is run.

Add Google OAuth credentials to your `translations.yml` file:

    google_drive_credentials:
      oauth:
        client_id: "YOUR_ID_GOES_HERE"
        client_secret: "YOUR_SECRET_GOES_HERE"

To get Google OAuth client_id and secret (for Native Application), you can go follow this link: https://console.developers.google.com/project
The first time you'll run i18n-docs, it will open a webpage with Google asking you to authorize the application.
Copy and paste the code in the prompt. The key will be saved in `.i18n-docs-access-token`.

Here is a list of options you can define, either
- when calling a method in ruby, by passing options as a hash
- when runing a rake task, by setting env variables
- or simply by writing them in `translations.yml`

    options:
      default_locale: 'en'            # The main locale, does only count for export
      locales: ['en','fr','de']       # Subset of locales to play with
      files: ['navigation.yml']       # Subset of filesname to use
      cleanup: false                  # Remove temporary files
      tmp_dir: 'tmp'                  # Temporary upload/download directory, default: './tmp/i18n-docs/'
      locales_dir: 'i18n'             # Final locales directory, default './_i18n' or './locales'
      single_locale_file: true        # All declared files grouped in one, default true / how to export 1/many=export=> 1, 1 =import=> 1

      # Future work
      logger_level: 0                 # Verbose?
      format: 'yml'                   # .yml or .json ? default: .yml


### For Rails user

Add the GEM to your Rails project:

    gem 'i18n-docs'

Let Rails know what locales you will be using. Add this to `config/application.rb`:

    module Web
      class Application < Rails::Application
        # add yml path
        config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*', '*.yml').to_s]
        # locals to support:
        config.i18n.available_locales = [:en,:de,:it,:fr]
      end
    end

This defines which languages and translation files to import from a Google Spreadsheet. The content of the Spreadsheet URL is stored to a file called e.g. `example1.yml` within folders `config/locales/en` and all other detected locales.

Following Rake tasks are added by the GEM to your Rails project:

* `rake i18n:export_translations`
  Export all language files to CSV files (ENV 'locale' have to set for non-'en' locales else only files contained in 'en' folder are considered)
* `rake i18n:import_translations`
  Download translations from Google Spreadsheet and save them to YAML files.


### For other users (not using Rails)

Pick-up any directory, add a `translations.yml` file (see above).

Add a Gemfile:

    source "https://rubygems.org"
    gem 'i18n-docs', :github => 'AntoineInsa/i18n-docs', :branch => 'v0.0.8'


Add a i18n-docs.rb:

    #!/usr/bin/env ruby

    require 'rubygems'
    require 'i18n-docs'

    # To import translations
    I18nDocs::TranslationsManager.import_translations()

    # To export translations
    # I18nDocs::TranslationsManager.export_translations()


You may have to install:
- Rbenv (https://github.com/sstephenson/rbenv)
- RubyGems (https://rubygems.org/pages/download)
- Bundler (http://bundler.io/)

And simply execute the file by running `bundle install` the first time, and `bundle exec ruby i18n-docs.rb`! Et voilà!


## CHANGELOG

### 0.0.8

Make it work outside of a Rails environment

### 0.0.7-2

Use translations.yml configuration file for Google OAuth credentials.

### 0.0.7-2

Use translations.yml configuration file for Google OAuth credentials.

### 0.0.7-1

Upgrade to OAuth before Google deprecation deadline.

### 0.0.4

Update docs, license. Push to Rubygems.org.

### 0.0.3

* Open sourced: changed name and description.

### 0.0.2

* removed loading of `awesome_print` from the rake task. It was breaking
  download

### Credits/License

This gem is sponsored by [local.ch](http://www.local.ch/). It is licensed under the [MIT license](http://en.wikipedia.org/wiki/MIT_License). If you're a ruby developer and want to work with us in Switzerland, please check out our [jobs page](http://local-ch.github.com/).
