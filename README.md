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



