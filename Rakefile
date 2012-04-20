require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'bundler/gem_tasks'
require 'i18n-docs'

task :default => [:test]

# Load tasks
Dir.glob('tasks/**/*.rake').each { |r| Rake.application.add_import r }
