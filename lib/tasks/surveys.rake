require 'rake'

task :add_oscars_survey => :environment do | t, args |
  b = Survey.create({name: "The Oscars", slug:"oscars-survey",credits:25})
end

task :add_travel_survey => :environment do | t, args |
  b = Survey.create({name: "Travel", slug:"travel-survey",credits:25})
end

