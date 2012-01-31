require 'test_helper'
require 'awesome_print'

# run test: ruby -I test/ -I lib/ test/unit/locale_builder_test.rb


module UnitTests
  class LocaleBuilderTest < Test::Unit::TestCase
    
    def setup
      @input_file = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'fixtures', 'test.csv')
      @output_file = 'test.yml'
      @builder = SpreadsheetI18n::CsvToYaml.new(@input_file, @output_file, ['de', 'en', 'fr', 'it'])
    end
    
    def test_store_translations
      # 
      # @builder.process_row({'key' => 'homepage.meta.title', 'en' => 'Phonebook of Switzerland', 'de' => 'Telefonbuch der Schweiz'})
      # @builder.process_row({'key' => 'homepage.meta.description', 'en' => 'Blabla desc', 'de' => 'Blabla Beschreibung'})
      # @builder.process_row({'key' => 'homepage.title', 'en' => 'Welcome @ local.ch', 'de' => 'Welcome bei local.ch'})
      
    end
    
    
    def test_process
      @builder.process
      
      ap @builder.translations['de']
      
      @builder.write_files
    end
    
  end
end