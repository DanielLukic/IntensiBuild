#!/usr/bin/rake

INTENSIBUILD_FOLDER = File.dirname(__FILE__)

if File.identical?(Dir.getwd, INTENSIBUILD_FOLDER)
  raise "ERROR: Rake must be called from you project root folder. Not from the IntensiBuild module folder."
end

$LOAD_PATH << "#{INTENSIBUILD_FOLDER}/src/ruby"

Dir.glob("#{INTENSIBUILD_FOLDER}/../*/src/ruby/tasks/**/*.rb").sort.each do |tasks|
  load tasks
end

Dir.glob("#{INTENSIBUILD_FOLDER}/../*/lib/rake/**/*.rb").sort.each do |tasks|
  load tasks
end

task :default => 'release:do'
