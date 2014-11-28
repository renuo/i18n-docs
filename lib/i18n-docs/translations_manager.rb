module I18nDocs
  SubTranslation = Struct.new(:yml, :csv, :tmp_file, :url, :existing_locales, :status)
  Status = Struct.new(:downloaded, :imported, :exported, :uploaded)

  class TranslationsManager

    def initialize
      check_rails

      set_config
      set_locales
      set_default_locale
      set_directories

      set_sub_translations

      set_google_drive_manager

      print_introduction
    end

    def print_introduction
      puts ""
      puts "  Detected locales: #{locales}"
      puts "  Main locale: \"#{default_locale}\""
      puts "  Declared files:"
      sub_translations.each {|sb| puts "    * #{sb.yml}: avalaible in #{sb.existing_locales}" }
      puts ""
    end

    def print_summary
      puts "Summary"
    end

    def clean_up
      # remove all tmp files
      sub_translations.each do |sub_translation|
        File.unlink(sub_translation.tmp_file)
      end
    end

    protected

    attr_accessor :config, :locales, :default_locale, :locales_dir, :tmp_dir, :google_drive_manager, :sub_translations

    def check_rails
      raise "'Rails' not found! Tasks can only run within a Rails application!" if !defined?(Rails)
    end

    def set_config
      # Get configuration file
      config_file = Rails.root.join('config', 'translations.yml')
      if File.exists?(config_file)
        self.config = YAML.load_file(config_file) if File.exists?(config_file)
      else
        raise "No config file 'config/translations.yml' found."
      end
    end

    def set_locales
      if defined?(I18n)
        self.locales = I18n.available_locales.map(&:to_s)
      else
        raise "I18n is not defined."
      end
    end

    def set_default_locale
      self.default_locale = (ENV['locale'] || I18n.default_locale || locales.first || 'en').to_s
    end

    def set_directories
      self.locales_dir = Rails.root.join('config', 'locales')
      self.tmp_dir = Rails.root.join('tmp')
      Dir.mkdir(tmp_dir) unless Dir.exist?(tmp_dir)
    end

    def set_google_drive_manager
      self.google_drive_manager = GoogleDriveManager.new(config["google_drive_credentials"])
    end

    def set_sub_translations
      self.sub_translations = []

      existing_sub_translations = {}
      locales.each do |locale|
        existing_sub_translations[locale] = Dir[File.join(locales_dir, locale, '*.yml')].map{|f| File.basename(f)}
      end

      config['files'].each do |yml_file,url|
        # Make sure targets are yml files
        yml_file = yml_file + ".yml" if yml_file !~ /\.yml$/
        # # Basename
        # base_name = File.basename(yml_file)
        # Create CSV pendant file
        csv_file = File.basename(yml_file).gsub('.yml', '.csv')
        # Temporary transit file
        tmp_file = File.join(tmp_dir, csv_file)
        # Existing locales
        existing_locales = existing_sub_translations.select{|locale,yml_files| yml_file.in?(yml_files)}.map{|locale,yml_files| locale}
        # Nothing done yet
        status = Status.new(false,false,false,false)

        self.sub_translations << SubTranslation.new(yml_file, csv_file, tmp_file, url, existing_locales, status)
      end
    end

  end
end


