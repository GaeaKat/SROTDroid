require 'rufus-scheduler'


scheduler = Rufus::Scheduler.new

scheduler.every '10s' do
  puts 'Hello... SROTD'
end

scheduler.join