module LocalchI18n

  class CsvToYaml

    attr_reader :input_file, :output_file, :locales, :translations

    def initialize(input_file, output_file, locales = [])
      @input_file = input_file
      @output_file = File.basename(output_file)
      @locales = locales.map(&:to_s)

      # init translation hash
      @translations = {}
      @locales.each do |locale|
        @translations[locale] = {}
      end
    end


    def write_files
      @locales.each do |locale|
        if defined?(Rails)
          output_file_path = Rails.root.join('config', 'locales', locale, @output_file)
          FileUtils.mkdir_p File.dirname(output_file_path)
        else
          output_file_path = "#{locale}_#{@output_file}"
        end
        File.open(output_file_path, 'w') do |file|
          final_translation_hash = {locale => @translations[locale]}
          file.puts YAML::dump(final_translation_hash)
        end
        puts "File '#{@output_file}' for language '#{locale}' written to disc (#{output_file_path})"
      end
    end


    def process
      CSV.foreach(@input_file, headers: true) do |row|
        process_row(row.to_hash)
      end
    end

    def process_row(row_hash)
      key = row_hash.delete('key')
      return unless key

      key_elements = key.split('.')
      @locales.each do |locale|
        raise "Locale missing for key #{key}! (locales in app: #{@locales} / locales in file: #{row_hash.keys.to_s})" if !row_hash.has_key?(locale)
        store_translation(key_elements, locale, row_hash[locale])
      end
    end


    def store_translation(keys, locale, value)
      return nil if value.nil?    # we don't store keys that don't have a valid value
      # Google Spreadsheet does not export empty strings and therefore we use '_' as a replacement char.
      value = '' if value == '_'

      keys.each(&:strip!)
      tree = keys[0...-1]
      leaf = keys.last
      data_hash = tree.inject(@translations[locale]) do |memo, k|
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
