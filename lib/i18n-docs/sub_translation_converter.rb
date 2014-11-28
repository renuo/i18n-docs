module I18nDocs

  class SubTranslationConverter

    attr_accessor :input_file, :input_format, :output_file, :output_format, :locales_dir, :locales, :raw_translations, :translations

    def initialize(input_file, input_format, output_file, output_format, locales_dir, locales = [])
      self.input_file = input_file
      self.input_format = input_format
      self.output_file = output_file
      self.output_format = output_format
      self.locales_dir = locales_dir
      self.locales = locales

      # init translation hash
      self.raw_translations = []
      self.translations = {}
      locales.each do |locale|
        translations[locale] = {}
      end
    end

    def process
      case input_format
      when "csv"
        CSV.foreach(input_file, headers: true) do |row|
          self.raw_translations << row.to_hash
        end
      else
        puts "Unknown input format #{input_format}"
      end

      if raw_translations
        raw_translations.each do |row|
          process_row(row)
        end
      end
    end

    def write_files
      # Write each sub_translation in each locale
      locales.each do |locale|
        output_file_path = File.join(locales_dir, locale, output_file)
        case output_format
        when "yml"
          File.open(output_file_path, 'w') do |file|
            file.puts YAML::dump({locale => translations[locale]})
          end
          puts "      #{output_file}: written to disk for language '#{locale}' (#{output_file_path})"
        else
          puts "      Unknown input format #{input_format}"
        end
      end
    end

    private

    def process_row(row_hash)
      key = row_hash.delete('key')

      unless key
        return
      else
        key_elements = key.split('.')
        locales.each do |locale|
          raise "Locale missing for key #{key}! (locales in app: #{locales} / locales in file: #{row_hash.keys.to_s})" unless row_hash.has_key?(locale)
          store_translation(key_elements, locale, row_hash[locale])
        end
      end
    end


    def store_translation(keys, locale, value)
      if value.nil?    # we don't store keys that don't have a valid value
        nil
      else
        # Google Spreadsheet does not export empty strings and therefore we use '_' as a replacement char.
        value = '' if value == '_'

        keys.each(&:strip!)
        tree = keys[0...-1]
        leaf = keys.last
        data_hash = tree.inject(translations[locale]) do |memo, k|
          if memo.has_key?(k)
            memo[k]
          else
            memo[k] = {}
          end
        end
        data_hash[leaf] = value
      end
    end

  end
end
