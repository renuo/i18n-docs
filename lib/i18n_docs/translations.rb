# encoding: utf-8
# Order of method calls
#  download_files
#  store_translations
#  clean_up
#
module I18nDocs
  class Translations

    attr_accessor :locales, :tmp_folder, :config_file, :csv_files

    def initialize(config_file = nil, tmp_folder = nil)
      @config_file = config_file
      @tmp_folder  = tmp_folder

      @csv_files = {}

      load_config
      load_locales
    end

    def load_locales
      @locales = []
      @locales = I18n.available_locales if defined?(I18n)
    end

    def load_config
      @settings = {}
      @settings = YAML.load_file(config_file) if File.exists?(config_file)
    end

    def download_files
      files = @settings['files']
      files.each do |target_file, url|
        #ensure .yml filename
        target_file = target_file + ".yml" if target_file !~ /\.yml$/
        # download file to tmp directory
        tmp_file = File.basename(target_file).gsub('.yml', '.csv')
        tmp_file = File.join(@tmp_folder, tmp_file)
        download(url, tmp_file)
        @csv_files[target_file] = tmp_file
      end
    end

    def store_translations
      @csv_files.each do |target_file, csv_file|
        converter = CsvToYaml.new(csv_file, target_file, @locales)
        converter.process
        converter.write_files
      end

      @csv_files
    end

    def clean_up
      # remove all tmp files
      @csv_files.each do |target_file, csv_file|
        File.unlink(csv_file)
      end
    end

    def download(url, destination_file)
      puts "Download '#{url}' to '#{destination_file}'"
      doc_data = open(url).read.force_encoding('UTF-8')
      File.open(destination_file, 'w') do |dst|
        dst.write(doc_data)
      end
    end

  end
end


