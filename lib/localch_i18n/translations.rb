require 'open-uri'


module LocalchI18n
  class Translations
    
    attr_accessor :locales
    
    def initialize
      load_config
      load_locales
      set_tmp
    end
    
    def set_tmp
      # Use ruby default tmp if Rails is unavailable
      @tmp_folder = defined?(Rails) ? Rails.root.join('tmp') : File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'test', 'fixtures')
    end
    
    def load_locales
      @locales = []
      @locales = I18n.available_locales if defined?(I18n)
    end
    
    def load_config
      config_file = defined?(Rails) ? Rails.root.join('config', 'translations.yml') : File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'test', 'fixtures', 'config.yml')
      @settings = {}
      @settings = YAML.load_file(config_file) if File.exists?(config_file)
    end
    
    def update_translations
      download_files
      store_translations
      clean_up
    end
    
    def download_files
      files = @settings['files']
      files.each do |target_file, url|
        # download file to tmp directory
        tmp_file = File.basename(target_file).gsub('.yml', '.csv')
        tmp_file = File.join(@tmp_folder, tmp_file)
        download(value, tmp_file)
        files[target_file] = tmp_file
      end
    end
    
    def store_translations
      files = @settings['files']
      files.each do |target_file, csv_file|
        converter = CsvToYaml.new(csv_file, target_file, @locales)
        converter.process
        converter.write_files
      end
    end
    
    def clean_up
      # remove all tmp files
      @settings['files'].each do |target_file, csv_file|
        File.unlink(csv_file)
      end
    end
    
    def download(url, destination_file)
      # open_uri()
      puts "download #{url} to #{destination_file}"
    end
    
  end
end


