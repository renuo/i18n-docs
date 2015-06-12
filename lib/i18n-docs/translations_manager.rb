module I18nDocs
  class TranslationsManager

    attr_accessor :config, :use_rails, :use_i18n, :ruby_options, :options, :locales, :default_locale, :locales_dir, :tmp_dir, :google_drive_manager, :sub_translations

    # Class methods

    def self.import_translations(ruby_options = {})
      translations_manager = I18nDocs::TranslationsManager.new(ruby_options)
      translations_manager.download_files
      translations_manager.import_translations
      translations_manager.clean_up
    end

    def self.export_translations(ruby_options = {})
      translations_manager = I18nDocs::TranslationsManager.new(ruby_options)
      translations_manager.export_translations
      translations_manager.upload_files
      translations_manager.clean_up
    end

    # Instance methods

    def initialize(ruby_options = {})
      check_rails()

      set_ruby_options(ruby_options)

      set_config()
      set_options()

      set_locales()
      set_default_locale()
      set_directories()

      set_sub_translations()

      set_google_drive_manager()

      print_introduction()
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

    def download_files
      puts "  Start downloading files:"
      sub_translations.each do |sub_translation|
        sub_translation.download
      end
    end

    def import_translations
      puts "  Start importing translations:"
      sub_translations.each do |sub_translation|
        sub_translation.import
      end
    end

    def export_translations
      puts "  Start exporting translations:"
      sub_translations.each do |sub_translation|
        sub_translation.export
      end
    end

    def upload_files
      puts "  Start uploading files:"
      sub_translations.each do |sub_translation|
        sub_translation.upload
      end
    end

    def clean_up
      # remove all tmp files
      unless options['cleanup'] == false
        puts "  Start cleaning files:"
        sub_translations.each do |sub_translation|
          sub_translation.clean_up
        end
      end
    end

    private

    def check_rails
      self.use_rails = !defined?(Rails).nil?
      self.use_i18n = !defined?(I18n).nil? && use_rails

      puts "Using rails: #{use_rails}"
      if use_rails
        puts "Using I18n: #{use_i18n}"
      end
    end

    def set_ruby_options(ruby_options)
      self.ruby_options = ruby_options
    end

    def set_config
      # Get configuration file
      config_file = Rails.root.join('config', 'translations.yml')
      if File.exists?(config_file)
        self.config = YAML.load_file(config_file) if File.exists?(config_file)
        self.config['options'] ||= {}
      else
        raise "No config file 'config/translations.yml' found."
      end
    end

    def set_options
      self.options = {
        'default_locale' => ENV['locale']   || config['options']['locale'],
        'locales'        => ENV['locales']  || config['options']['locales'],
        'files'          => ENV['files']    || config['options']['files'],
        'cleanup'        => ENV['cleanup']  || config['options']['cleanup'],
        'debugger'       => ENV['debugger'] || config['options']['debugger'],
      }
    end

    def set_locales
      if defined?(I18n)
        self.locales = I18n.available_locales.map(&:to_s)
        self.locales = locales & options['locales'] if options['locales']
      else
        raise "I18n is not defined."
      end
    end

    def set_default_locale
      self.default_locale = (options['locale'] || I18n.default_locale || locales.first || 'en').to_s
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
        unless options['files'] && !yml_file.in?(options['files'])

          # Existing locales
          existing_locales = existing_sub_translations.select{|locale,yml_files| yml_file.in?(yml_files)}.map{|locale,yml_files| locale}

          self.sub_translations << SubTranslation.new(yml_file,url,existing_locales,self)
        end
      end
    end

  end
end


