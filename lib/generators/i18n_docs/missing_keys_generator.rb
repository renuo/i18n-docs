module I18nDocs
  module Generators
    class MissingKeysGenerator < Rails::Generators::Base
      desc "Show missing keys"

      def main
		    finder = LocalchI18n::MissingKeysFinder.new(I18n.backend)
		    finder.find_missing_keys
		  end
		end
	end
end