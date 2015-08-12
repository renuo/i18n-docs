$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "localch_i18n/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'localch-i18n'
  s.version     = LocalchI18n::VERSION
  s.authors     = ["Georg Kunz"]
  s.email       = 'georg.kunz@local.ch'
  s.homepage    = 'https://github.com/local-ch/spreadsheet-i18n'
  s.summary     = "local.ch i18n helpers"
  s.description = "GEM providing helper scripts to manage i18n translations. Features: check YAML files for missing translations; export YAML files to CSV; download translations from multiple Google spreadsheets and store to YAML files"

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ['lib']

  s.requirements << 'Ruby >= 1.9.2'
  s.required_ruby_version = '>= 1.9.2'
  
  s.add_dependency('rails', '>= 3.0.0')
  s.add_dependency('i18n')
  
  s.add_development_dependency('mocha')
  s.add_development_dependency('awesome_print')
end
