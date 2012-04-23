module I18nDocs
  module Generators
    class NormalizeGenerator < Rails::Generators::Base
      desc "Normalize locale files by converting tabs to spaces"

      class_option  :spaces,  :type => :string, :default => '2', 
          :desc => "Spaces for each tab"

      class_option  :overwrite,  :type => :boolean, :default => false, 
          :desc => "Overwrite existing locale files?"

      argument      :locales, :type => :array,  :default => [], 
          :desc => "List of locales to normalize"

      def tabs_to_spaces
        say "Normalizing tabs for locales: #{locales} - with #{spaces} spaces"
        locales.empty? ? normalize_for(:all) : for_locales
      end

      protected

      def for_locales
        locales.each {|locale| normalize_for locale }
      end        

      def normalize_for locale = :en
        path = (locale != :all) ? File.join(locales_root, locale) : locales_root
        replacement = spaces_pr_tab
        say "Normalizing tabs for: #{locale}"
        say "In folder: #{path}"

        files(path).each do |file|
          normalize_file_content file
        end
        say "Normalize completed"        
      end        

      def normalize_file_content file
        say "normalizing file: #{file} ..."
        content = File.open(file).read
        replaced_content = content.gsub /\t/, spaces_pr_tab
        
        File.open(new_file(file), 'w') do |f|
          f.puts replaced_content
        end
      end        

      def new_file file
        overwrite? ? file : normalized_file_name(file)
      end

      def normalized_file_name file
        '_' + file
      end

      def overwrite?
        options[:overwrite]
      end

      def files path
        Dir[File.join(path,'*.yml')]
      end

      def spaces_pr_tab
        @spaces ||= (1..spaces).to_a.inject("") {|res, e| res << ' ' }
      end

      def spaces
        options[:spaces].to_i
      end

      def num_spaces
        spaces.to_i
      end

      # def sub file
      #   file.gsub /["$`]/, "\\#{$1}"
      # end

      def locales_root
        Rails.root.join 'config', 'locales'
      end
    end
  end
end
