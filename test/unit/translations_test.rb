require 'test_helper'
require 'awesome_print'

# run test: ruby -I test/ -I lib/ test/unit/locale_builder_test.rb


module UnitTests
  class TranslationsTest < Test::Unit::TestCase
    
    def setup
      # @input_file = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'fixtures', 'test.csv')
      # @output_file = 'test.yml'
      # @builder = SpreadsheetI18n::CsvToYaml.new(@input_file, @output_file, ['de', 'en', 'fr', 'it'])
      
      @translations = LocalchI18n::Translations.new
      @translations.locales = ['de', 'en', 'fr', 'it']
    end
    
    def test_translations
      ap @translations
      
      @translations.store_translations
      @translations.clean_up
    end
    
    
  end
end