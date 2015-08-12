require 'rufus-scheduler'
require 'rubygems'
require 'bundler/setup'
require './droidConfig'
require './google'
require './reddit'
require './database'

require 'pp'
require 'date'
scheduler = Rufus::Scheduler.new
red=Reddit.instance
Database.instance.initializeTables
subredditRegex=/r\/([A-Za-z0-9][A-Za-z0-9_]{2,20})/i
scheduler.every '5m',:overlap => false,:first => :now do
  modmail=red.get_modmail(DroidConfig.instance['modmail']['subreddit'])
  modmail.each do |message|
    if not Database.instance.seenbefore?(message.name)
      print "Got a modmail!\n"
      Database.instance.addmodmail(message.name)
      match=message.body.scan(subredditRegex)
      matchs=match.map { |m| m[0]}
      matchs.uniq!
      matchs.each do |subreddit|
        sub=red.get_subreddit(subreddit)
        if not sub.nil?
          print "Checking subreddit: #{subreddit}\n"
          created=Time.at(sub.created_utc)
          print "created at #{created}\n"
          oldEnough=created < (Time.now.utc - DroidConfig.instance['modmail']['daysEligable']*24*60*60 )
          print "Is subreddit old enough? #{oldEnough}\n"
          subscribers = sub.subscribers
          print "Has #{subscribers} subscribers\n"
          populatedEnough=subscribers > DroidConfig.instance['modmail']['subscribers']
          print "is subreddit populated enough? #{populatedEnough}\n"
          featuredRow=GoogleD.instance.getFeaturedSubreddit(subreddit)
          featuredLink=nil
          if(not featuredRow.nil?)
            featuredLink=GoogleD.instance.getFeaturedLink(featuredRow)
          end
          featuredBefore=!featuredRow.nil?
          print "Has been featured before? #{featuredBefore} "
          if featuredBefore
              print "At = #{featuredLink}"
          end
          print "\n"
        end
      end
    end
  end
end
pp GoogleD.instance.getFeaturedSubreddit("pokemon")
scheduler.join

#GoogleD.instance.save

