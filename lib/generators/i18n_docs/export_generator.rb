module I18nDocs
  module Generators
    class ExportGenerator < Rails::Generators::Base
      desc "Export locale files as CSV files"

      argument     :base_locale,  :type => :string,  :default => 'en', :desc => "Base locale (default = en)"
      
      def main_flow
        show_files
        export_files
      end        

      protected

      def show_files
        say ""
        say "  Detected locales: #{locales}", :green
        say "  Detected files:"
        input_files.each {|f| say "    * #{File.basename(f)}", :green }
      end        

      def export_files
        say ""
        say "  Start exporting files:", :green
        say ""
        say "    source dir: #{source_dir}"
        say "    output dir: #{output_dir}"
        
        input_files.each do |file|
          file = File.basename(file)
          exporter = LocalchI18n::TranslationFileExport.new(source_dir, file, output_dir, locales)
          exporter.export
        end
        
        say ""
        say "  CSV files can be removed safely after uploading them manually to Google Spreadsheet."
        say ""
      end


      def source_dir
        Rails.root.join('config', 'locales')
      end

      def output_dir
        Rails.root.join('tmp')
      end
    
      def locales
        I18n.available_locales
      end
    
      def input_files
        Dir[File.join(source_dir, base_locale, '*.yml')]
      end
    end
  end
end