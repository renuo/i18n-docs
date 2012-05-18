# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "i18n_googledocs"
  s.version = "0.1.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Georg Kunz", "Ivan Jovanovic", "Jeremy Seitz", "Kristian Mandrup"]
  s.date = "2012-05-18"
  s.description = "GEM providing helper scripts to manage i18n translations in Google Docgem. Features: check YAML files for missing translations; export YAML files to CSV; download translations from multiple Google spreadsheets and store to YAML files"
  s.email = "jeremy.seitz@local.ch"
  s.extra_rdoc_files = [
    "LICENSE.md",
    "README.md"
  ]
  s.files = [
    "CHANGELOG",
    "Gemfile",
    "LICENSE.md",
    "README.md",
    "Rakefile",
    "VERSION",
    "i18n_googledocs.gemspec",
    "lib/generators/i18n_docs/copy_master_generator.rb",
    "lib/generators/i18n_docs/export_generator.rb",
    "lib/generators/i18n_docs/import_generator.rb",
    "lib/generators/i18n_docs/locales_generator.rb",
    "lib/generators/i18n_docs/missing_keys_generator.rb",
    "lib/generators/i18n_docs/normalize_generator.rb",
    "lib/generators/i18n_docs/templates/locale.erb",
    "lib/i18n_googledocs.rb",
    "lib/localch_i18n/csv_to_yaml.rb",
    "lib/localch_i18n/missing_keys_finder.rb",
    "lib/localch_i18n/translation_file_export.rb",
    "lib/localch_i18n/translations.rb",
    "lib/localch_i18n/translator.rb",
    "lib/localch_i18n/translator/service.rb",
    "lib/localch_i18n/util.rb",
    "lib/tasks/store_translations.rake",
    "tasks/test.rake",
    "test/fixtures/config.yml",
    "test/fixtures/de/header.yml",
    "test/fixtures/en/header.yml",
    "test/fixtures/minimal.csv",
    "test/fixtures/test.csv",
    "test/test_helper.rb",
    "test/unit/csv_to_yaml_test.rb",
    "test/unit/translation_file_export_test.rb",
    "test/unit/translations_test.rb"
  ]
  s.homepage = "http://github.com/kristianmandrup/i18n-docs"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Maintain translations in Google Docs and export them to your Rails project."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<deep_merge>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2.8.0"])
      s.add_development_dependency(%q<rdoc>, [">= 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<jeweler>, [">= 1.8.3"])
      s.add_development_dependency(%q<simplecov>, [">= 0.5"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<awesome_print>, [">= 0"])
    else
      s.add_dependency(%q<deep_merge>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2.8.0"])
      s.add_dependency(%q<rdoc>, [">= 3.12"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<jeweler>, [">= 1.8.3"])
      s.add_dependency(%q<simplecov>, [">= 0.5"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<awesome_print>, [">= 0"])
    end
  else
    s.add_dependency(%q<deep_merge>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2.8.0"])
    s.add_dependency(%q<rdoc>, [">= 3.12"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<jeweler>, [">= 1.8.3"])
    s.add_dependency(%q<simplecov>, [">= 0.5"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<awesome_print>, [">= 0"])
  end
end

