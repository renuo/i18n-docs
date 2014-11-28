# encoding: utf-8
# Order of method calls
#  download_files
#  store_translations
#  clean_up
#
module I18nDocs
  class TranslationsImporter < TranslationsManager

    def initialize()
      super
    end

    def download_files
      puts "  Start downloading files:"
      sub_translations.each do |sub_translation|
        tmp_file = File.join(tmp_dir, sub_translation.csv)
        if download(sub_translation.url, tmp_file)
          sub_translation.status.downloaded = true
        end
      end
    end

    def import_translations
      puts "  Start importing translations:"
      sub_translations.each do |sub_translation|
        # csv file
        source_file = File.join(tmp_dir, sub_translation.csv)
        # x yml files
        target_file = sub_translation.yml

        puts "    From #{sub_translation.csv}"
        converter = SubTranslationConverter.new(source_file, "csv", target_file, "yml", locales_dir, locales)
        converter.process
        converter.write_files

        sub_translation.status.imported = true
      end
    end

    private

    def download(url, destination_file)
      puts "    #{File.basename(destination_file)}: downloaded from '#{url}' (#{destination_file})"

      is_google_drive = /^google-drive\|(.*)/

      if result = url.match(is_google_drive)
        google_drive_title = result[1]
        google_drive_manager.download(google_drive_title,destination_file)
      else
        doc_data = open(url).read.force_encoding('UTF-8')
        File.open(destination_file, 'w') do |dst|
          dst.write(doc_data)
        end
      end
      true
    end

  end
end


