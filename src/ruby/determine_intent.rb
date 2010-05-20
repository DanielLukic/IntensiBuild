#!/usr/bin/env ruby

apk_path = ARGV.shift
raise "missing apk argument" unless apk_path

properties_path = apk_path.sub(/\.apk$/, '.properties').sub(/\.unaligned/, '')
properties = File.readlines(properties_path)

classname_line = properties.select { |line| line =~ /midlet\.classname/ }.first.chomp
package_line = properties.select { |line| line =~ /midlet\.package/ }.first.chomp

classname = classname_line.sub /.*=[ \t]*/, ''
package = package_line.sub /.*=[ \t]*/, ''

puts "#{package}/.#{classname}"
