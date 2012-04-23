module LocalchI18n
  class TranslationFileExport
    include LocalchI18n::Util
    
    attr_accessor :translations
    attr_reader :main_locale, :current_locale
    
    def initialize(source_dir, source_file, output_dir, locales, options = {})
      @source_dir = source_dir
      @source_file = source_file
      @auto_translate = options[:auto_translate]

      @output_file = File.join(output_dir, source_file.gsub('.yml', '.csv'))
      @locales = locales.map {|l| l.to_s.downcase }
      
      @translations = {}
    end
    
    
    def export
      load_translations
      write_to_csv
    end
        
    def write_to_csv
      @main_locale = main_locale = @locales.include?('en') ? 'en' : @locales.first
      
      puts "    #{@source_file}: write CSV to '#{@output_file}' \n\n"
      
      CSV.open(@output_file, "wb") do |csv|
        csv << (["key"] + @locales)
                
        if @translations.empty? || !@translations[main_locale] || @translations[main_locale].keys.empty?
          puts %Q{Translations #{@source_file} for #{main_locale} could not be processed, likely due to a YAML syntax error. 
Please try again with the --normalize option. 

The problem could also be due to an invalid locale code. Please check the i18n.available_locales setting in config/application.rb} 
          exit(0)
        end

        @translations[main_locale].keys.each do |key|
          values = @locales.map do |locale|
            @translations[locale][key] if @translations[locale]
          end
          csv << values.unshift(key)
        end
      end
      
    end
    
    
    def load_translations
      @locales.each do |locale|
        @current_locale = locale
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
      
      # puts "  input file: #{input_file}"
      load_translations_for input_file, locale
    end
    
  end
  
end