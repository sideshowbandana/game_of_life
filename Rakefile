require File.expand_path("game_of_life.rb")
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :run do
  b = Board.new(60, 120)
  b.run
end
