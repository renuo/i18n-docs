Gem::Specification.new do |s|
  s.name        = 'localch-i18n'
  s.version     = '0.0.2'
  s.date        = '2012-01-29'
  s.summary     = "local.ch i18n helpers"
  s.description = "GEM providing helper scripts to manage i18n translations. Features: check YAML files for missing translations; export YAML files to CSV; download translations from multiple Google spreadsheets and store to YAML files"
  s.authors     = ["Georg Kunz"]
  s.email       = 'georg.kunz@local.ch'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/local-ch/spreadsheet-i18n'

  # dependencies
  s.add_dependency(%q<bundler>)
  s.add_dependency(%q<rake>)
  # other dependencies?
end
