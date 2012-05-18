module LocalchI18n
	class Translator
	  # Subclass this class in order to support another translation service
	  class Service

	  	# uses to_lang
	    def initialize options = {}
	    	configure!
	    end

	    def translate text, locale
				text.translate(locale)  
			end  	

			protected

			def configure!
	    	load_service!
				use_key!
	    end

	    def load_service!
	    	require 'to_lang'
	    end

	    def use_key!
	    	ToLang.start(I18n.google_translation_key)
	    end
		end
	end
end
	      