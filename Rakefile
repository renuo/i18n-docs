# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docgem.rubygemgem.org/read/chapter/20 for more options
  gem.name 				= "i18n_googledocs"
  gem.homepage 		= "http://github.com/kristianmandrup/i18n-docs"
  gem.summary     = "Maintain translations in Google Docs and export them to your Rails project."
  gem.description = "GEM providing helper scripts to manage i18n translations in Google Docgem. Features: check YAML files for missing translations; export YAML files to CSV; download translations from multiple Google spreadsheets and store to YAML files"
  gem.authors     = ["Georg Kunz", "Ivan Jovanovic", "Jeremy Seitz", "Kristian Mandrup"]
  gem.email       = 'jeremy.seitz@local.ch'
end
Jeweler::RubygemsDotOrgTasks.new

