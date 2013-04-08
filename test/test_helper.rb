require 'test/unit'
require 'fileutils'
require 'mocha/setup'

require 'i18n-docs'

Rails = Struct.new(:dummy)

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



