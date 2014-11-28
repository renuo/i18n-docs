module I18nDocs
  class TranslationsExporter < TranslationsManager

    def initialize
      super
    end

    def export_translations
      puts "  Start exporting translations:"
      sub_translations.each do |sub_translation|
        translations = load_translations(sub_translation.yml)
        write_to_csv(sub_translation.tmp_file, translations)
        sub_translation.status.exported = true
      end
    end

    def upload_files
      puts "  Start uploading files:"
      sub_translations.each do |sub_translation|
        puts "    #{sub_translation.csv} uploaded to Google Drive"
        if google_drive_manager.upload(sub_translation.tmp_file, sub_translation.csv)
          sub_translation.status.uploaded = true
        end
      end
    end

    private

    attr_accessor :source_file, :source_dir, :output_dir, :locales

    def load_translations(file_pattern)
      translations = {}
      locales.each do |locale|
        translation_hash = load_language(locale,file_pattern)[locale]
        translations[locale] = flatten_translations_hash(translation_hash)
      end
      translations
    end

    def load_language(locale,file_pattern)
      puts "      #{@file_pattern}: load translations for '#{locale}'"
      input_file = File.join(locales_dir, locale, file_pattern)
      YAML.load_file(input_file) if File.exists?(input_file)
    end

    def flatten_translations_hash(translations, parent_key = [])
      flat_hash = {}

      translations.each do |key, t|
        current_key = parent_key.dup << key
        if t.is_a?(Hash)
          # descend
          flat_hash.merge!(flatten_translations_hash(t, current_key))
        else
          # leaf -> store as value for key
          flat_hash[current_key.join('.')] = t
        end
      end
      flat_hash
    end

    def write_to_csv(output_file, translations)
      puts "    #{source_file}: write CSV to '#{output_file}' \n\n"

      CSV.open(output_file, "wb") do |csv|
        # header
        csv << (["key"] + locales)

        translations[default_locale].keys.each do |key|
          values = locales.map do |locale|
            translations[locale][key]
          end
          csv << values.unshift(key)
        end
      end
    end
  end

end
