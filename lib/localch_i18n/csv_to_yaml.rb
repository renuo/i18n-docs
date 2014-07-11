module LocalchI18n

  class RabbitHole
    def initialize(t, k)
      @t = t
      @k = k
    end
    def [](key)
      key = key.gsub(/\s+/, "")
      @k = @k + '.' + key
      return self
    end
    def to_s
      @t[@k].to_s
    end
    def ==(str)
      @t[@k].to_s == str
    end
    alias_method :eql?, :==
    alias_method :equal?, :==
  end

  class LocaleHashTable
    def initialize
      @t = {}
    end

    def [](key)
      key = key.gsub(/\s+/, "")
      return RabbitHole.new(@t, key)
    end

    def []=(key, value)
      key = key.gsub(/\s+/, "")
      @t[key] = value
    end
  end

  class CsvToYaml

    attr_reader :input_file, :output_file, :locales, :translations

    def initialize(input_file, output_file, locales = [])
      @input_file = input_file
      @output_file = File.basename(output_file)
      @locales = locales.map(&:to_s)

      # init translation hash
      @translations = {}
      @locales.each do |locale|
        @translations[locale] = LocaleHashTable.new
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

      key_elements = key.strip()
      @locales.each do |locale|
        raise "Locale missing for key #{key}! (locales in app: #{@locales} / locales in file: #{row_hash.keys.to_s})" if !row_hash.has_key?(locale)
        store_translation(key_elements, locale, row_hash[locale])
      end
    end


    def store_translation(key, locale, value)
      # we don't store keys that don't have a valid value
      return nil if value.nil?
      # Google Spreadsheet does not export empty strings and therefore we use '_' as a replacement char.
      value = '' if value == '_'
      @translations[locale][key] = value
    end

  end

end
