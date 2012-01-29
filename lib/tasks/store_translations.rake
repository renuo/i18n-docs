
namespace :i18n do
  
  desc "Download all locales from Google Spreadsheet"
  task :download do
    puts "downloading from Google Spreadsheet"
  end
  
  task :store_locales do
    
    locales = {'en' => {}, 
               'de' => {},
               'fr' => {},
               'it' => {}}
    
    
    CSV.foreach("test.csv", headers: true) do |row|
      require 'pp'
      # pp row
      
      
      key = row['KEY'].split('.')
      
      
    end
  end
  
  
  
  desc "Export all translations of all languages to one CSV file"
  task :export_to_csv => :environment do
    finder = SpreadsheetI18n::MissingKeysFinder.new(I18n.backend)
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


