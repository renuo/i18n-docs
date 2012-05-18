require 'localch_i18n/translator/service'

module LocalchI18n
  # Subclass this class in order to support another translation service
  class Translator
    attr_accessor :options 

    def initialize options = {}
      @options = options
    end

    # TODO: Refactor to use inject
    def auto_translate(flat_hash)      
    	raise '#auto_translate method requires a #current_locale method in the same module' unless respond_to? :current_locale

    	translated_hash = {}
    	flat_hash.each do |key, text|
				translated_hash[key] = translate_it text, current_locale
			end
			translated_hash
    end

    def translate_it text, locale
      text_has_args? ? translate_with_args(text) : text.translate(current_locale)
    end

    def service= service
      raise ArgumentError, "Must be a subclass of LocalchI18n::TranslationService, was #{service}" unless service.kind_of?(LocalchI18n::TranslationService)
      @service = service
    end

    protected

    def service
      @service ||= LocalchI18n::TranslationService.new options[:service]
    end

    # split out args parts and pure text parts
    # translate non-arg parts and use arg parts "as is", while re-assembling
    def translate_with_args text, locale      
      parts = text.split /(%\{\w+\})/
      parts.inject("") do |res, part|
        res << var_translate(part, locale)
      end
    end

    # translate only non-arg parts
    def var_translate text, locale
      is_var?(text) ? text : service.translate(text, locale)
    end

    # is it a variable part?
    def is_var? text
      text =~ /%\{\w+\}/
    end

    def text_has_args? text
      text =~ /%\{/
    end
  end
end