
namespace :i18n do
  
  desc "Find and list translation keys that do not exist in all locales"
  task :missing_keys => :environment do
    finder = LocalchI18n::MissingKeysFinder.new(I18n.backend)
    finder.find_missing_keys
  end
  
  desc "Download translations from Google Spreadsheet and save them to YAML files."
  task :update_translations => :environment do
    raise "'Rails' not found! Tasks can only run within a Rails application!" if !defined?(Rails)
    
    config_file = Rails.root.join('config', 'translations.yml')
    raise "No config file 'config/translations.yml' found." if !File.exists?(config_file)
    
    tmp_dir     = Rails.root.join('tmp')
    
    translations = LocalchI18n::Translations.new(config_file, tmp_dir)
    translations.download_files
    translations.store_translations
    translations.clean_up
    
  end
  
  desc "Export all translations of all languages to one CSV file"
  task :export_to_csv => :environment do
    finder = LocalchI18n::MissingKeysFinder.new(I18n.backend)
    all_keys = finder.all_keys
    
    available_locales = I18n.available_locales
    
    # ap all_keys
    # ap available_locales
    
    # Add ignoring of keys! (from ignore file)
    # by filtering all_keys
    
    # iterate through all keys and get all translations
    
    # write line to CSV file
    
    
    # Get value for key for a given language
    # Returns true if key exists in the given locale
    # values = available_locales.map do |locale|
    #   I18n.locale = locale
    #   # I18n.translate(key, :raise => true)
    #   I18n.translate('tel.extended.area_label', :raise => false)
    # end
    # ap values
    
    CSV.open("all_translations.csv", "wb") do |csv|
      csv << (["KEY"] + available_locales.map {|l| l.upcase})
      
      all_keys.each do |key|
        values = available_locales.map do |locale|
          I18n.locale = locale
          # I18n.translate(key, :raise => true)
          I18n.translate(key, :raise => false)
        end
        
        csv << (values.unshift(key))
      end
    end
    
    
  end
  
end


