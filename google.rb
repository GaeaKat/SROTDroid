require 'google_drive'

require 'singleton'
class GoogleD
  include Singleton

  def initialize
    @client = Google::APIClient.new(application_name: 'SROTDroid', application_version: '2.1')
    @googleConfig=DroidConfig.instance['google']
    authorize
    refresh
    getWorksheet
  end

  def authorize
    @key = Google::APIClient::KeyUtils.load_from_pkcs12(
        @googleConfig['p12'],
        @googleConfig['secret'])

    @asserter = Google::APIClient::JWTAsserter.new(
        @googleConfig['accountid'],
        ['https://www.googleapis.com/auth/drive'],
        @key
    )
  end


  def refresh
    @client.authorization = @asserter.authorize
    @session = GoogleDrive.login_with_oauth(@client.authorization.access_token)
  end

  def getfiles
    @session.files.each do |file|
      pp file.title
    end
  end

  def getWorksheet
    @ws=@session.spreadsheet_by_key(@googleConfig['spreadsheet']).worksheets[0]
  end
  def getSpreadsheet
    @ws
  end
  def setCell(row,col,value)
    @ws[row,col]=value
    @ws.save
  end
  def reload
    getSpreadsheet.reload
  end

  def save
    getSpreadsheet.save
  end
end
