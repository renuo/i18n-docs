Gem::Specification.new do |s|
  s.name        = 'spreadsheet-i18n'
  s.version     = '0.0.1'
  s.date        = '2012-01-29'
  s.summary     = "Google Spreadsheet translation downloader"
  s.description = "GEM providing helper scripts to download translations from multiple Google spreadsheets and store them to YAML files. Allowing translation management in Google Spreadsheet."
  s.authors     = ["Georg Kunz"]
  s.email       = 'georg.kunz@local.ch'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/local-ch/spreadsheet-i18n'

  # dependencies
  s.add_dependency(%q<bundler>)
  s.add_dependency(%q<rake>)
  # s.add_dependency(%q<capistrano>, [">= 2.9.0"])
end