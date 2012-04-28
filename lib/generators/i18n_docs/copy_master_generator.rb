require 'localch_i18n/util'

module I18nDocs
  module Generators
    class CopyMasterGenerator < Rails::Generators::Base
			include LocalchI18n::Util

      desc "Copy master locale files to other locales to be used as base"

      class_option  :into,  :type => :array, :default => [], 
          :desc => "Which locales to copy master files into"

      class_option  :auto_translate,  :type => :boolean, :default => false, 
          :desc => "Use Google Translate API to auto-translate?"

      argument      :master, :type => :string,  :default => nil, 
          :desc => "Master locale, default = I18n.default_locale"

      def main_flow        
        check_translate_key if options[:auto_translate]
        copy_master master_locale
      end        

      protected

      def check_translate_key
        unless I18n.google_translation_key
          say %q{You must set I18n.google_translation_key to a valid API key.
  See https://code.google.com/apis/console/b/0/?api=translate}, :red
          exit(0)
        end

        say "Using google translation key: #{I18n.google_translation_key}"
        ToLang.start(I18n.google_translation_key)
      end

      def master_locale
        master || I18n.default_locale || :en
      end

      def locales
        @locales ||= options[:into].empty? ? I18n.available_locales : options[:into]
      end

      def unnormalized_files path
        Dir[File.join(path,'[^_]*.yml')]
      end

      def locales_root
        Rails.root.join 'config', 'locales'
      end

      def locale_names
      	locales.join(' ')
      end

      def master_locale
        master || I18n.default_locale || :en
      end

      def make_local_copy file, locale
      	local_content = content.sub /#{master_locale}:/, "#{locale}:"
      	file = file.gsub /\\/, '/'
      	local_file = file.gsub /\/#{master_locale}\//, "\/#{locale}\/"

      	File.open(local_file, 'w') do |f|
      		f.puts local_content
      	end

      	perform_auto_translate(local_file, locale) if auto_translate?
      end

     	attr_accessor :content
      attr_reader :current_locale

      def auto_translate?
        options[:auto_translate]
      end

     	def perform_auto_translate(local_file, locale)
        @current_locale = locale
     		flat_hash = flatten_translations_hash load_translations_for(local_file, locale)

        translated_hash = {}
        flat_hash.each do |key, text|
          translation = text
          trans_row_hash = row_to_hash key, translation
          translated_hash.deep_merge!(trans_row_hash)
        end
        translated_hash

        File.open(local_file, 'w') do |file|
          final_translation_hash = {locale => translated_hash}
          file.puts YAML::dump(final_translation_hash)
        end
     	end

      def locale_path locale
        (locale != :all) ? File.join(locales_root, locale) : locales_root
      end

      def copy_master locale = :en
        path = locale_path(locale)
        say "Using #{locale} as master for locales: #{locale_names}"
        unnormalized_files(path).each do |file|
        	say "Making local copies for: #{file}"
        	self.content = File.open(file).read
          locales.each{|locale| make_local_copy file, locale }
        end       
      end
		end
	end
end