#!/usr/bin/rake

intensibuild_folder = File.dirname(__FILE__)

$LOAD_PATH << "#{intensibuild_folder}/src/ruby"

Dir.glob("#{intensibuild_folder}/src/ruby/tasks/**/*.rb").each do |tasks|
  require tasks.sub("#{intensibuild_folder}/src/ruby/", '')
end

task :default => 'release:do'
