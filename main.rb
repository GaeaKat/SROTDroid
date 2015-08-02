require 'rufus-scheduler'
require 'rubygems'
require 'bundler/setup'
require './droidConfig'
require './reddit'
require 'pp'
scheduler = Rufus::Scheduler.new

scheduler.every '10s' do
  puts 'Hello... SROTD'
end

red=Reddit.instance
pp red.get_modmail("nekosune")[0]
scheduler.join