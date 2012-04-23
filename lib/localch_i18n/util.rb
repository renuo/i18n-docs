module LocalchI18n
	module Util
		def load_translations_for input_file, locale
			translations = {}
      translations = YAML.load_file(input_file) if File.exists?(input_file)

      # Hack to fix "bug" when 'no' for Norway encountered. 
      # Parser turns it into false as the key
      no = translations[false]
      translations['no'] = no

      puts "  No translations found!" and return if translations.empty?
      puts "  Missing or bad translations root key:" and return if !translations[locale]
      translations[locale]
    end

    def row_to_hash(key, value)
    	res = {}
    	keys = key.split('.')
    	keys << value
      h = keys.reverse.inject(res) do |a, n| 
	      if n != keys.last	
	      	{ n => a }
	      else
	      	n
	      end
      end      
    end    

    # options:
    #  - parent_key = []
    #  - auto_translate 
    def flatten_translations_hash(translations, options = {:parent_key => [] })
      flat_hash = {}
      parent_key = options[:parent_key] || []
      translations.each do |key, t|
        current_key = parent_key.dup << key
        if t.is_a?(Hash)
          # descend
          options ||= {}
          options.merge!(:parent_key => current_key)
          flat_hash.merge!(flatten_translations_hash(t, options))
        else
          # leaf -> store as value for key
          flat_hash[current_key.join('.')] = t
        end
      end
			if options[:auto_translate] || auto_translate?
      	auto_translate(flat_hash) 
      else
      	flat_hash
      end
    end

    def auto_translate?
    	false
    end

    def auto_translate(flat_hash)
    	raise '#auto_translate method requires a #current_locale method in the same module' unless respond_to? :current_locale
    	translated_hash = {}
    	flat_hash.each do |key, text|
				translated_hash[key] = translate_it text, current_locale
			end
			translated_hash
    end

    def translate_it text, locale
      text.translate(current_locale)
    end    
  end
end
