require 'redd'
require 'singleton'
class Reddit
  include Singleton


  def get_modmail(subreddit)
    params={}
    params[:mark]=false
    @redditclient.request_object(:get,"/r/#{subreddit}/about/message/inbox.json",params)
  end

  def get_subreddit(subredditName)
    @redditclient.subreddit_from_name(subredditName)
  end

  def initialize
    @redditConfig=DroidConfig.instance['reddit']
    @redditclient=Redd.it(:script,@redditConfig['clientid'],@redditConfig['secret'],@redditConfig['username'],@redditConfig['password'],user_agent: "SROTDroid V 2.1")
    @redditclient.authorize!
  end
end