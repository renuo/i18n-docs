module I18nDocs
  module Generators
    class CopyMasterGenerator < Rails::Generators::Base
      desc "Copy master locale files to other locales to be used as base"

      class_option  :into,  :type => :array, :default => [], 
          :desc => "Which locales to copy master files into"

      argument      :master, :type => :string,  :default => nil, 
          :desc => "Master locale, default = I18n.default_locale"

      def main_flow        
        copy_master master_locale
      end        

      protected

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
      end

     	attr_accessor :content

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