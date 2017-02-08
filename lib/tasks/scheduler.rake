desc "This task is called by the Heroku scheduler add-on"

task :fakejob => :environment do
  puts "Doing the fake job"
  sleep 3
  puts "Fake job finished"
end

