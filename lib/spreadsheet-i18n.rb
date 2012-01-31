# require 'rake'

# load rake tasks in case GEM is included within rails project

require 'csv'
require 'spreadsheet_i18n/missing_keys_finder'
require 'spreadsheet_i18n/csv_to_yaml'
require 'spreadsheet_i18n/translations'


if defined?(Rails)
  class I18nTask < Rails::Railtie
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'tasks/*.rake')].each { |f| load f }
    end
  end
end



