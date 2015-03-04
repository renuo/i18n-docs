module I18nDocs
  class GoogleDriveManager

    require "rubygems"
    require "google/api_client"
    require "google_drive"

    def initialize(credentials)
      set_session
    end

    def get_files
      # Gets list of remote files.
      for file in session.files
        p file.title
      end
    end

    def upload(source_path, destination_title)

      if file = session.spreadsheet_by_title(destination_title)
        # update from spreadsheet
        raw_data = CSV.read(source_path)
        puts "    Upload #{destination_title}: started"
        update_all_cells(file,raw_data)
        puts "    Upload #{destination_title}: finished"
      else
        # create a new spreadsheet (convert => true)
        session.upload_from_file(source_path, destination_title, :convert => true)
      end
    end

    def download(source_title, destination_path)
      # export from Google = import from app
      file = session.spreadsheet_by_title(source_title)
      if file
        puts "    Download #{source_title}: started"
        file.export_as_file(destination_path)
        puts "    Download #{source_title}: finished"
        true
      else
        puts "File #{source_title} was not found on Google Drive"
        false
      end
    end

    private

    attr_accessor :access_token, :session

    def set_access_token
      # Authorizes with OAuth and gets an access token.
      client = Google::APIClient.new
      auth = client.authorization
      auth.client_id     = ENV['GOOGLE_DRIVE_CLIENT_ID']
      auth.client_secret = ENV['GOOGLE_DRIVE_CLIENT_SECRET']
      auth.scope =
          "https://www.googleapis.com/auth/drive " +
          "https://docs.google.com/feeds/ " +
          "https://docs.googleusercontent.com/ " +
          "https://spreadsheets.google.com/feeds/"
      auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
      print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
      print("2. Enter the authorization code shown in the page: ")
      system( 'open "'+auth.authorization_uri+'"' )
      auth.code = $stdin.gets.chomp
      auth.fetch_access_token!
      self.access_token = auth.access_token
    end

    def set_session
      set_access_token
      self.session = GoogleDrive.login_with_oauth(access_token)
    end

    def update_all_cells(drive_file,raw_data)
      puts "      getting worksheet: start"
      ws = drive_file.worksheets[0]
      puts "      getting worksheet: stop"

      # erase everything first
      (1..ws.num_rows).each do |row|
        (1..ws.num_cols).each do |col|
          ws[row,col] = ""
        end
      end

      # write then
      raw_data.each_with_index do |data, row|
        data.each_with_index do |val, col|
          ws[row + 1, col + 1] = val || ""
        end
      end

      begin
        # crop blank space around
        ws.max_cols = ws.num_cols
        ws.max_rows = ws.num_rows
        puts "      saving: start"
        ws.save
        puts "      saving: stop"
      rescue Nokogiri::XML::XPath::SyntaxError => e
        puts "Nokogiri Syntax error"
        puts "#{e.message}"
      rescue GoogleDrive::Error => e
        puts "Google Drive error"
        puts "#{e.message}"
      end
    end

  end
end
