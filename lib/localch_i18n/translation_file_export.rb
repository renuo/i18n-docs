module LocalchI18n
  class TranslationFileExport
    
    attr_accessor :translations
    
    def initialize(source_dir, source_file, output_dir, locales)
      @source_dir = source_dir
      @source_file = source_file
      
      @output_file = File.join(output_dir, source_file.gsub('.yml', '.csv'))
      @locales = locales.map {|l| l.to_s.downcase }
      
      @translations = {}
    end
    
    
    def export
      load_translations
      write_to_csv
    end
    
    
    def write_to_csv
      main_locale = @locales.include?('en') ? 'en' : @locales.first
      
      puts "    #{@source_file}: write CSV to '#{@output_file}' \n\n"
      
      CSV.open(@output_file, "wb") do |csv|
        csv << (["key"] + @locales)
        
        @translations[main_locale].keys.each do |key|
          values = @locales.map do |locale|
            @translations[locale][key]
          end
          csv << values.unshift(key)
        end
      end
      
    end
    
    
    def load_translations
      @locales.each do |locale|
        translation_hash = load_language(locale)
        unless translation_hash.blank?
          @translations[locale] = flatten_translations_hash(translation_hash)
        else
          puts "Error: No translations for locale - #{locale}"
        end
      end
    end
    
    def load_language(locale)
      
      puts "    #{@source_file}: load translations for '#{locale}'"
      
      input_file = File.join(@source_dir, locale, @source_file)
      translations = {}
      # puts "  input file: #{input_file}"
      translations = YAML.load_file(input_file) if File.exists?(input_file)

      # Hack to fix "bug" when 'no' for Norway encountered. 
      # Parser turns it into false as the key
      no = translations[false]
      translations['no'] = no

      puts "  No translations found!" and return if translations.empty?
      puts "  Missing or bad translations root key:" and return if !translations[locale]
      translations[locale]
    end
    
    def flatten_translations_hash(translations, parent_key = [])
      flat_hash = {}
      translations.each do |key, t|
        current_key = parent_key.dup << key
        case t
        when Hash
          # descend
          flat_hash.merge!(flatten_translations_hash(t, current_key))
        when nil
          puts "nil for key: #{key}"
        else
          # leaf -> store as value for key
          flat_hash[current_key.join('.')] = t
        end
      end
      flat_hash
    end
    
  end
  
end