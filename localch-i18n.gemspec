$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "localch_i18n/version"

Gem::Specification.new do |s|
  s.name        = 'localch-i18n'
  s.version     = LocalchI18n::VERSION
  s.date        = '2012-01-29'
  s.summary     = "local.ch i18n helpers"
  s.description = "GEM providing helper scripts to manage i18n translations. Features: check YAML files for missing translations; export YAML files to CSV; download translations from multiple Google spreadsheets and store to YAML files"
  s.authors     = ["Georg Kunz"]
  s.email       = 'georg.kunz@local.ch'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/local-ch/spreadsheet-i18n'

  # dependencies
  s.add_dependency('bundler')
  s.add_dependency('rake')
  
  s.add_development_dependency('mocha')
  s.add_development_dependency('awesome_print')
end
