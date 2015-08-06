# local.ch i18n helpers

GEM providing helper scripts to manage i18n translations. 

Features: 

* check YAML files for missing translations
* export YAML files to CSV files for uploading them to Google Spreadsheet
* download translations from multiple Google spreadsheets and store to YAML files

## Rake Tasks

Following Rake tasks are added by the GEM to your Rails project:

* rake i18n:export_translations
  Export all language files to CSV files (only files contained in 'en' folder are considered)
* rake i18n:import_translations
  Download translations from Google Spreadsheet and save them to YAML files.
* rake i18n:missing_keys
  Find and list translation keys that do not exist in all locales

## Installation

Add the GEM to your Rails project:

    gem 'localch-i18n', :git => 'git@github.com:local-ch/ws-localch-i18n.git'


The rake task `i18n:import_translations` requires following configuration file in `config/translations.yml`:

    files:
      example1.yml: "https://docs.google.com/spreadsheet/pub?key=0ApnemdIdiDXedGNrcTZoYnNqbjZQb09qeWpsX0JveWc&single=true&gid=0&output=csv"
      example2.yml: "https://docs.google.com/spreadsheet/pub?key=0ApnemdIdiDXsfrtrcTZoYnNqbjZQb09qeWpsX0JveWc&single=true&gid=0&output=csv"

It defines which translations files should be created by exporting a Google Spreadsheet. The content of the Spreadsheet URL is stored to a file called e.g. `example1.yml` within folders `config/locales/en` and all other detected locales.

## Usage

* First run `rake i18n:export_translations`. This will place current translations in the `tmp` folder of the application.
* Upload generated files to Google Docs
* In Google Docs, use option `File -> Publish To the Web` to make link to CSV spreadsheet you need for next step
* In `config` folder of the application, create `translations.yml` file with structure that is explained above in the installation section.
* Run `rake i18n:export_translations` to import translations from the Google Docs.
* From now on you should only update translations in Google Docs and run `rake i18n:import_translations` in the application to get changes.

## Error Handling

I case of the error `OpenSSL::SSL::SSLError: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed` when running `rake i18n:import_translations`
Follow this: http://stackoverflow.com/questions/12562697/opensslsslsslerror-ssl-connect-returned-1-errno-0-state-sslv3-read-server-ce?answertab=active#tab-top


## CHANGELOG

### 0.0.2

* removed loading of `awesome_print` from the rake task. It was breaking
  download

