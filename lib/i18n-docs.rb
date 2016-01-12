require 'csv'
require 'yaml'
require 'open-uri'
require 'i18n_docs/missing_keys_finder'
require 'i18n_docs/csv_to_yaml'
require 'i18n_docs/translations'
require 'i18n_docs/translation_file_export'

if defined?(Rails)
  module I18nDocs
    class Railtie < Rails::Railtie
      rake_tasks do
        Dir[File.join(File.dirname(__FILE__), 'tasks/*.rake')].each { |f| load f }
      end
    end
  end
end
