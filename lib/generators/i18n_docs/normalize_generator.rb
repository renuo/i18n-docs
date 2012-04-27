require 'pathname'
require 'fileutils'

module I18nDocs
  module Generators
    class NormalizeGenerator < Rails::Generators::Base
      desc "Normalize locale files by converting tabs to spaces"

      class_option  :spaces,  :type => :string, :default => '2', 
          :desc => "Spaces for each tab"

      class_option  :overwrite,  :type => :boolean, :default => false, 
          :desc => "Overwrite existing locale files?"

      class_option  :delete,  :type => :boolean, :default => false, 
          :desc => "Delete old normalized files?"

      class_option  :accept,  :type => :boolean, :default => false, 
          :desc => "Accept normalized files"

      class_option  :debug,  :type => :boolean, :default => false, 
          :desc => "Turn debug mode on?"

      argument      :locales, :type => :array,  :default => [], 
          :desc => "List of locales to normalize"

      def main
        delete_normalized and return if delete?
        accept_normalized and return if accept?
        tabs_to_spaces
      end
                    
      protected

      def delete?
        options[:delete]
      end

      def debug?
        options[:delete]
      end

      def accept?
        options[:accept]
      end

      def delete_normalized
        locales.each {|locale| delete_for locale }        
      end

      def delete_for locale = :all
        path = locale_path(locale)
        say "Deleting normalized files for: #{locale}"
        normalized_files(path).each do |file|
          say "Deleting: #{file}" if debug?
          File.delete file
        end       
      end

      def accept_normalized
        locales.each {|locale| accept_for locale }        
      end

      def accept_for locale = :all
        path = locale_path(locale)
        say "Accepting normalized files for: #{locale}"
        normalized_files(path).each do |file|          
          new_file_name = File.basename(file).gsub /^_/, ''
          file_path = File.join(File.dirname(file), new_file_name)          
          FileUtils.mv file, file_path

          say "Accepted for: #{new_file_name}" if debug?
        end       
      end


      def tabs_to_spaces
        say "Normalizing tabs for locales: #{locales} - with #{spaces} spaces"
        locales.empty? ? normalize_for(:all) : for_locales
      end

      def for_locales
        locales.each {|locale| normalize_for locale }
      end        

      def normalize_for locale = :en
        path = locale_path(locale)
        replacement = spaces_pr_tab
        say "Normalizing for: #{locale}" if debug?
        say "In folder: #{path}" if debug?

        files(path).each do |file|
          normalize_file_content file
        end
        say "Normalize completed", :green        
      end        

      def locale_path locale
        (locale != :all) ? File.join(locales_root, locale) : locales_root
      end

      def normalize_file_content file
        say "Normalizing file: #{file}" if debug?

        content = File.open(file).read
        replaced_content = content.gsub /\t/, spaces_pr_tab
        replaced_content = content.gsub /^---/, ''        

        File.open(new_file(file), 'w') do |f|
          f.puts replaced_content
        end
      end        

      def new_file file
        overwrite? ? file : normalized_file_name(file)
      end

      def normalized_file_name file_name
        new_file_name = '_' + File.basename(file_name)
        File.join(File.dirname(file_name), new_file_name)          
      end

      def overwrite?
        options[:overwrite]
      end

      def files path
        Dir[File.join(path,'*.yml')]
      end

      def normalized_files path
        Dir[File.join(path,'_*.yml')]
      end

      def unnormalized_files path
        Dir[File.join(path,'[^_]*.yml')]
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

      def locales_root
        Rails.root.join 'config', 'locales'
      end
    end
  end
end
