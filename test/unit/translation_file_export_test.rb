require 'test_helper'

# run test: ruby -I test/ -I lib/ test/unit/locale_builder_test.rb

module UnitTests
  class TranslationFileExportTest < Test::Unit::TestCase
    include TestHelper

    def setup
      create_tmp_dir

      source_dir = fixture_path
      source_file = 'header.yml'
      output_dir = tmp_dir
      locales = ['en', 'de']

      @exporter = LocalchI18n::TranslationFileExport.new(source_dir, source_file, output_dir, locales)
      @output_file = File.join(output_dir, 'header.csv')
    end

    def teardown
      remove_tmp_dir
    end


    def test_export
      assert !File.exists?(@output_file)
      @exporter.export
      assert File.exists?(@output_file), "Expected to have a CSV file written"
    end

    def dtest_load_language
      translations = @exporter.load_language('de')

      assert translations, "Expected to return a hash with translations"
      assert_equal translations['header']['search'], "Finden"
    end

    def dtest_flatten_translations_hash
      translation_hash = {'a' => {
                            'I' => '1',
                            'II' => '2',
                            'III' => {
                              'Z' => '3'
                            }
                          },
                          'b' => '4'
                         }

      flat = @exporter.flatten_translations_hash(translation_hash, [])
      assert_equal '1', flat['a.I']
      assert_equal '2', flat['a.II']
      assert_equal '3', flat['a.III.Z']
      assert_equal '4', flat['b']
    end

    def dtest_load_translations
      assert_empty @exporter.translations
      @exporter.load_translations

      assert @exporter.translations['de']
      assert @exporter.translations['en']
      assert_equal 'Finden', @exporter.translations['de']['header.search']
      assert_equal 'Telefonbuch', @exporter.translations['de']['header.phonebook']
      assert_equal '(c) local.ch', @exporter.translations['de']['copyright']
    end

    def dtest_write_to_csv
      @exporter.translations = {'de' => {'numbers.one' => 'eins'},
                                'en' => {'numbers.one' => 'one'}}

      @exporter.write_to_csv

      output = File.read(@output_file)
      assert_match(/^key,(en|de|,){3}$/, output)
      assert_match(/^numbers.one,(one|eins|,){3}$/, output)
    end


  end
end
