if ARGV.size != 2
    puts "Usage: #{$0} filename partname"
    puts
    puts "Will update the version.properties file and put a three-part value in there:"
    puts "version=<release>.<version>.<build>"
    puts
    puts "Example: #{$0} version.properties build"
    puts "Example: #{$0} version.properties version"
    puts "Example: #{$0} version.properties release"
    puts
    exit 1
end

target_file_name = ARGV.shift

if File.exist?(target_file_name)
    version_line = File.readlines(target_file_name).select { |l| l =~ /^version/ }.first
else
    version_line = "version=0.0.0"
end

old_version = version_line.split('=').last
release,version,build = old_version.split('.').map { |v| v.to_i }

part = ARGV.shift.downcase
if part == 'release'
    release += 1
    version = 0
    build = 0
end
if part == 'version'
    version += 1
    build = 0
end
if part == 'build'
    build += 1
end

if ( build > 99 )
    version += 1
    build = 0
end

if ( version > 99 )
    release += 1
    version = 0
    build = 0
end

if ( release > 99 )
    release = 0
    version = 0
    build = 0
end

output = "version=#{release}.#{version}.#{build}"
File.open(target_file_name,'w') do |f|
    f.puts output
    f.puts "date=#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}"
end
puts output

exit 0
