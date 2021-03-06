module I18nDocs
  class CsvToYaml
    attr_reader :input_file, :output_file, :locales, :translations

    def self.root_path
      @root_path ||= defined?(Rails) ? Rails.root : Pathname.new(Dir.pwd)
    end

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
        output_file_path = self.class.root_path.join('config', 'locales', locale, @output_file)
        FileUtils.mkdir_p File.dirname(output_file_path)

        File.open(output_file_path, 'w') do |file|
          final_translation_hash = { locale => @translations[locale] }
          file.puts YAML.dump(final_translation_hash)
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
        unless row_hash.key?(locale)
          raise "Locale missing for key #{key}! (locales in app: #{@locales} / locales in file: #{row_hash.keys})"
        end
        store_translation(key_elements, locale, row_hash[locale])
      end
    end

    def store_translation(keys, locale, value)
      return nil if value.nil? # we don't store keys that don't have a valid value
      # Google Spreadsheet does not export empty strings and therefore we use '_' as a replacement char.
      value = '' if value == '_'

      keys.each(&:strip!)
      tree = keys[0...-1]
      leaf = keys.last
      data_hash = tree.inject(@translations[locale]) do |memo, k|
        if memo.is_a? Hash
          if memo.key?(k)
            memo[k]
          else
            memo[k] = {}
          end
        else
          raise "Error around key '#{keys.join '.'}': Expected #{memo.inspect} to be a Hash"
        end
      end

      if data_hash.is_a? String
        raise "Error around key '#{keys.join '.'}': Expected #{data_hash.inspect} to be a Hash"
      end

      data_hash[leaf] = value
    end
  end
end
