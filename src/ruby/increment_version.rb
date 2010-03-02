def now_as_date
  Time.now.strftime('%Y-%m-%d %H:%M:%S')
end

if ARGV.size < 1
  puts "Usage: #{$0} filename partname(s)"
  puts
  puts "Will update the version.properties file and put a three-part value in there:"
  puts "version=<release>.<version>.<build>"
  puts
  puts "Example: #{$0} version.properties minor"
  puts "Example: #{$0} version.properties major"
  puts "Example: #{$0} version.properties version"
  puts
  exit 1
end

target_file_name = ARGV.shift

if File.exist?(target_file_name)
  lines = File.readlines(target_file_name)

  version_line = lines.select { |l| l =~ /^version/ }.first || "version=0.0.0"
  build_line = lines.select { |l| l =~ /^build/ }.first || "build=0"
  date_line = lines.select { |l| l =~ /^date/ }.first || "date=#{now_as_date}"

  old_version_string = version_line.split('=').last
  version, major, minor = old_version_string.split('.').map { |v| v.to_i }

  old_build_string = build_line.split('=').last
  build = old_build_string.to_i

  date = date_line.split('=').last
else
  version = major = minor = 0
  build = 0
  date = now_as_date
end

parts = ARGV.map {|part| part.downcase}

if parts.include?('version')
  version += 1
  major = 0
  minor = 0
end

if parts.include?('major')
  major += 1
  minor = 0
end

if parts.include?('minor')
  minor += 1
end

if parts.include?('build')
  build += 1
end

if parts.include?('date')
  date = now_as_date
end

if ( minor > 99 )
  major += 1
  minor = 0
end

if ( major > 99 )
  version += 1
  major = 0
  minor = 0
end

if ( version > 99 )
  raise "version numbers exhausted"
end

output = <<END
version=#{version}.#{major}.#{minor}
build=#{build}
date=#{date}
END

File.open(target_file_name, 'w') do |f|
  f.puts output
end

puts output

exit 0
