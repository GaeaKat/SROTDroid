require 'redd'
require 'singleton'
class Reddit
  include Singleton


  def get_modmail(subreddit)
    @redditclient.subreddit_modmail(subreddit)
  end

  def initialize
    @redditConfig=DroidConfig.instance['reddit']
    @redditclient=Redd.it(:script,@redditConfig['clientid'],@redditConfig['secret'],@redditConfig['username'],@redditConfig['password'],user_agent: "SROTDroid V 2.1")
    @redditclient.authorize!
  end
end