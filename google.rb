require 'google_drive'

require 'singleton'
require "faraday"
class GoogleD
  include Singleton

  def initialize
    @client = Google::APIClient.new(application_name: 'SROTDroid', application_version: '2.1')
    @googleConfig=DroidConfig.instance['google']
    Faraday.default_connection=Faraday.new(nil, ssl:{ verify: false })
    authorize
    refresh
    getNominations
    getFeatured

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

  def getNominations
    @wsn=@session.spreadsheet_by_key(@googleConfig['nominationsSpreadsheet']).worksheets[0]
  end
  def getFeatured
    @wsf=@session.spreadsheet_by_key(@googleConfig['featuredSpreadsheet']).worksheets[0]
  end
  def getSpreadsheet
    @ws
  end

  def getFeaturedSubreddit(subname)
    @wsf.num_rows.downto(1) do |row|
      if @wsf[row,1].downcase==subname.downcase
        return row
      end
    end
    return nil
  end

  def getFeaturedLink(row)
    @wsf[row,4]
  end
  def isFeatured?(subname)
    not getFeaturedSubreddit(subname).nil?
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
