# require 'rake'

# load rake tasks in case GEM is included within rails project

require 'csv'
require 'yaml'
require 'open-uri'
require 'i18n_docs/missing_keys_finder'
require 'i18n_docs/csv_to_yaml'
require 'i18n_docs/translations'
require 'i18n_docs/translation_file_export'


if defined?(Rails)
  class I18nDocs::Railtie < Rails::Railtie
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'tasks/*.rake')].each { |f| load f }
    end
  end
end

