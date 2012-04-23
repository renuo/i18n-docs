module I18nDocs
  module Generators
    class ImportGenerator < Rails::Generators::Base
      desc "Import locale files from CSV files"

      def main_flow
        find_translations_file
        import
      end        

      protected

			def find_translations_file
	    	config_file = Rails.root.join('config', 'translations.yml')
	    	raise "No config file 'config/translations.yml' found." if !File.exists?(config_file)
	    end

			def import		   		   
		    translations = LocalchI18n::Translations.new(config_file, tmp_dir)
		    translations.download_files
		    translations.store_translations
		    translations.clean_up
		  end

		  def tmp_dir
		  	Rails.root.join('tmp')
		  end
		end
	end
end