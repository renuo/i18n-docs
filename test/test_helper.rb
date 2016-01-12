require 'test/unit'
require 'fileutils'
require 'mocha/setup'
require 'i18n-docs'

Rails = Struct.new(:dummy)

module TestHelper
  def sample_csv_uri
    'https://docs.google.com/spreadsheet/pub?key=0ApnemdIdiDXedEpiVFR1RkdWMDhnTTgtdzRJMWZMLUE&single=true&gid=0&output=csv'
  end

  def fixture_path
    File.join(File.expand_path(File.dirname(__FILE__)), 'fixtures')
  end

  def tmp_dir
    File.join(fixture_path, 'tmp')
  end

  def create_tmp_dir
    FileUtils.mkdir(tmp_dir) unless File.exist?(tmp_dir)
  end

  def remove_tmp_dir
    FileUtils.rmtree(tmp_dir)
  end
end
