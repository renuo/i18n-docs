require 'test_helper'

# run test: ruby -I test/ -I lib/ test/unit/locale_builder_test.rb

module UnitTests
  class TranslationsTest < Test::Unit::TestCase
    include TestHelper

    def setup
      create_tmp_dir

      config_file = File.join(fixture_path, 'config.yml')
      @translations = I18nDocs::Translations.new(config_file, tmp_dir)
      @translations.tmp_folder = tmp_dir
      @translations.locales = %w(de en)

      @fixture_file = File.join(fixture_path, 'minimal.csv')
      @tmp_file = File.join(tmp_dir, 'downloaded.csv')
      @output_file = File.join(tmp_dir, 'test.yml')

      Rails.stubs(:root).returns(stub(join: @output_file))
    end

    def teardown
      remove_tmp_dir
    end

    def test_download
      assert !File.exist?(@tmp_file)
      sheet_url = 'https://docs.google.com/spreadsheets/d/1PbmkqamXuNyP7gnVARpeCfV8rA7WvX98dTqsQB3Wdts/pub?output=csv'
      @translations.download(sheet_url, @tmp_file)
      assert File.exist?(@tmp_file), "Expected to have downloaded Google Spreadsheet to '#{@tmp_file}'"
    end

    def test_cleanup
      @translations.csv_files = { 'dummy.yml' => @tmp_file }
      File.open(@tmp_file, 'w') {}
      assert File.exist?(@tmp_file)
      @translations.clean_up
      assert !File.exist?(@tmp_file), 'Expected to delete file'
    end

    def test_store_translations
      assert !File.exist?(@output_file)

      @translations.csv_files = { @output_file => @fixture_file }
      @translations.store_translations

      assert File.exist?(@output_file)
    end

    def test_download_files
      expected_file = File.join(tmp_dir, 'download.csv')
      assert !File.exist?(expected_file)
      @translations.download_files
      assert File.exist?(expected_file)
      assert File.open(expected_file).read.encoding.name == 'UTF-8'
    end
  end
end
