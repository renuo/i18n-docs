require 'test/unit'
require 'fileutils'
require 'localch-i18n'
require 'mocha/mini_test'
require 'awesome_print'

module TestHelper
  
  def fixture_path
    File.join(File.expand_path(File.dirname(__FILE__)), 'fixtures')
  end
  
  def tmp_dir
    File.join(fixture_path, 'tmp')
  end
  
  def create_tmp_dir
    FileUtils::mkdir(tmp_dir) if ! File.exists?(tmp_dir)
  end
  
  def remove_tmp_dir
    FileUtils::rmtree(tmp_dir)
  end
  
end



