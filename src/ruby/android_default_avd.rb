#!/usr/bin/env ruby

android_home = ARGV.shift || '/usr/local/android'
android_executable = File.join(android_home, 'tools', 'android')

commandline = %Q[#{android_executable} list avds | grep "Name:" | sort]
avds = %x[#{commandline}].gsub(/.*Name: /, '').split("\n").select {|e| not e =~ /_[l|p|L|P]$/}

avds.each do |avd|
  next unless avd.downcase == 'default'
  puts avd
  exit 0
end

avds.each do |avd|
  next unless avd.downcase =~ /default/
  puts avd
  exit 0
end

puts avds.first
exit 0
