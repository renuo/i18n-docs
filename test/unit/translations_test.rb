require 'test_helper'

# run test: ruby -I test/ -I lib/ test/unit/locale_builder_test.rb

module UnitTests
  class TranslationsTest < Test::Unit::TestCase
    include TestHelper

    def setup
      create_tmp_dir

      config_file = File.join(fixture_path, 'config.yml')
      @translations = LocalchI18n::Translations.new(config_file, tmp_dir)
      @translations.tmp_folder = tmp_dir
      @translations.locales = ['de', 'en']

      @fixture_file = File.join(fixture_path, 'minimal.csv')
      @tmp_file = File.join(tmp_dir, 'downloaded.csv')
      @output_file = File.join(tmp_dir, 'test.yml')

      Rails.stubs(:root).returns(stub(:join => @output_file))
    end

    def teardown
      remove_tmp_dir
    end

    def test_download
      assert !File.exists?(@tmp_file)
      @translations.download("https://docs.google.com/spreadsheet/pub?key=0ApnemdIdiDXedEpiVFR1RkdWMDhnTTgtdzRJMWZMLUE&single=true&gid=0&output=csv", @tmp_file)
      assert File.exists?(@tmp_file), "Expected to have downloaded Google Spreadsheet to '#{@tmp_file}'"
    end

    def test_cleanup
      @translations.csv_files = {'dummy.yml' => @tmp_file}
      File.open(@tmp_file, "w") {}
      assert File.exists?(@tmp_file)
      @translations.clean_up
      assert !File.exists?(@tmp_file), "Expected to delete file"
    end

    def test_store_translations
      assert !File.exists?(@output_file)

      @translations.csv_files = {@output_file => @fixture_file}
      @translations.store_translations

      assert File.exists?(@output_file)
    end

    def test_download_files
      expected_file = File.join(tmp_dir, 'download.csv')
      assert !File.exists?(expected_file)
      @translations.download_files
      assert File.exists?(expected_file)
      assert File.open(expected_file).read.encoding.name == 'UTF-8'
    end

  end
end
