$LOAD_PATH.push File.expand_path('../lib', __FILE__)
# Maintain your gem's version:
require 'i18n_docs/version'

# encoding: utf-8
Gem::Specification.new do |s|
  s.name        = 'i18n-docs'
  s.version     = I18nDocs::VERSION
  s.date        = '2013-05-10'
  s.summary     = 'Maintain translations in Google Docs and export them to your Rails project.'
  s.description = 'GEM providing helper scripts to manage i18n translations in Google Docs. '\
                  'Features: check YAML files for missing translations; export YAML files to CSV; '\
                  'download translations from multiple Google spreadsheets and store to YAML files'
  s.authors     = ['Georg Kunz', 'Ivan Jovanovic', 'Jeremy Seitz', 'Eduard Schäli', 'Robin Wunderlin',
                   'Esteban Pastorino', 'Krzysztof Sakwerda']
  s.email       = 'eduard.schaeli@localsearch.ch'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/local-ch/i18n-docs'

  # dependencies
  s.add_dependency('rake')

  s.add_development_dependency('mocha', '~> 0.13.3')
  s.add_development_dependency('test-unit', '~> 3.1.7')
  s.add_development_dependency('simplecov', '~> 0.14.1')
  s.add_development_dependency('rubocop', '~> 0.48.0')
end
