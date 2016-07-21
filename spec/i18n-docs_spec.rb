require 'spec_helper'
require 'pry'

include Helpers

# High level integration specs
describe I18nDocs do
  describe "I18nDocs::TranslationsManager.import_translations" do
    it 'imports the right translations' do
      output_path = File.join(fixture_path,'output')

      options = {
        'default_locale'      => 'en',
        'locales'             => ['en','fr','de'],
        'files'               => {'activities.yml' => File.join(fixture_path, 'csv', 'translations.csv')},
        'cleanup'             => true,
        'debugger'            => false,

        'i18n-docs-path'      => fixture_path,

        'tmp_dir'             => 'tmp',
        'locales_dir'         => output_path,
        'single_locale_file'  => true,
        'include_locale_key'  => true,
        'force_fallback'      => true,
      }

      I18nDocs::TranslationsManager.import_translations(options)

      expected_translations = {
        'en' => {
          'numbers' => {
            'one'   => 'one',
            'two'   => 'two',
            'three' => 'three'
          }
        }
      }
      original_translation = YAML.load_file(File.join(output_path,'en.yml'))
      expect(original_translation).to eq(expected_translations)

      expected_translations = {
        'fr' => {
          'numbers' => {
            'one'   => 'un',
            'two'   => 'deux',
            'three' => 'trois'
          }
        }
      }
      original_translation = YAML.load_file(File.join(output_path,'fr.yml'))
      expect(original_translation).to eq(expected_translations)

      remove_output_dir
    end
  end

  describe "I18nDocs::TranslationsManager.export_translations" do
    context "in general" do
      it 'exports the right translations' do
        output_path = File.join(fixture_path,'output')

        options = {
          'default_locale'      => 'en',
          'locales'             => ['en','fr','de'],
          'files'               => {'activities.yml' => File.join(output_path, 'translations.csv')},
          'cleanup'             => true,
          'debugger'            => false,

          'i18n-docs-path'      => fixture_path,

          'tmp_dir'             => 'tmp',
          'locales_dir'         => File.join(fixture_path,'yml'),
          'single_locale_file'  => true,
          'include_locale_key'  => true,
          'force_fallback'      => true,
        }

        I18nDocs::TranslationsManager.export_translations(options)

        csv = File.read(File.join(output_path,'translations.csv'))

        expected_csv = """key,en,fr,de
numbers.one,one,un,eins
numbers.three,three,trois,drei
numbers.two,two,deux,zwei
"""
        expect(csv).to eq(expected_csv)

        remove_output_dir
      end
    end

    context "with respect to conversion" do
      before(:all) do
        output_path = File.join(fixture_path,'output')

        files = {'activities.yml' => File.join(fixture_path,'csv','special_characters.csv')}

        # can only be run locally
        if using_google_drive = false
          files = {'test.yml' => "google-drive|19KIURJtd1w9umkBiye7GfEyII5_YqRXX13DfTFw2VUI|test"}
          google_drive_credentials = {
            'oauth' => {
              'client_id'     => '746170120421-pmp6o92mb5ago5rujtcs799gvj79m48m.apps.googleusercontent.com',
              'client_secret' => 'oA8fbQPXPlvi5wJaKb-iPMfP',
            }
          }
        end

        options = {
          'default_locale'      => 'en',
          'locales'             => ['en'],
          'files'               => files,
          'cleanup'             => false,
          'debugger'            => false,

          'i18n-docs-path'      => fixture_path,

          'google_drive_credentials' => google_drive_credentials,

          'tmp_dir'             => 'tmp',
          'locales_dir'         => output_path,
          'single_locale_file'  => true,
          'include_locale_key'  => true,
          'force_fallback'      => true,
        }

        I18nDocs::TranslationsManager.import_translations(options)

        @original_translation = YAML.load_file(File.join(output_path,'en.yml'))
      end

      after(:all) do
        remove_output_dir
      end

      let(:translations) { @original_translation }

      it "converts a normal string" do
        expect(translations['en']['normal_string']).to eq("normal")
      end
      it "converts an empty string" do
        expect(translations['en']['empty_string']).to eq("Empty string")
      end
      it "converts a special empty string '_'" do
        expect(translations['en']['special_empty_string']).to eq("")
      end
      it "converts a whitespace" do
        expect(translations['en']['whitespace']).to eq("Whitespace")
      end
      it "converts a special whitespace '__'" do
        expect(translations['en']['special_whitespace']).to eq(" ")
      end
      it "converts a simple multiline " do
        expect(translations['en']['simple_multiline']).to eq("un deux trois")
      end
      it "converts quoted multiline" do
        expect(translations['en']['quoted_multiline']).to eq("un deux trois")
      end
      it "converts simple multiline with comma" do
        expect(translations['en']['simple_multiline_with_comma']).to eq("un, deux, trois")
      end
      it "converts a quoted multiline with comma" do
        expect(translations['en']['quoted_multiline_with_comma']).to eq("un, deux, trois")
      end
      it "converts a not fully quoted multiline " do
        expect(translations['en']['not_fully_quoted_multiline']).to eq("\"un\ndeux")
      end
      it "converts simple comma" do
        expect(translations['en']['simple_comma']).to eq(",")
      end
      it "converts quoted comma" do
        expect(translations['en']['quoted_comma']).to eq(",")
      end
      it "converts key with space " do
        expect(translations['en']['key with space']).to eq("key")
      end
      it "converts true" do
        expect(translations['en']['boolean_true']).to eq(true)
      end
      it "converts false" do
        expect(translations['en']['boolean_false']).to eq(false)
      end
      it "converts an array" do
        expect(translations['en']['array']).to eq(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"])
      end
      it "converts a html element " do
        expect(translations['en']['html_element']).to eq("<a a=\\\"one.com\\\" target=\\\"_blank\\\">One</a>")
      end
      it "converts a quoted html element" do
        expect(translations['en']['quoted_html_element']).to eq("<a a=\"one.com\" target=\"_blank\">One</a>")
      end
    end
  end
end
