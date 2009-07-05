
require File.join( File.dirname( $0 ), 'build.rb' )
require File.join( File.dirname( $0 ), 'configuration.rb' )
require File.join( File.dirname( $0 ), 'target.rb' )



load File.join( File.dirname( $0 ), '..', 'config', '_groups.rb' )
load File.join( File.dirname( $0 ), '..', 'config', '_targets.rb' )

if ARGV.size == 0
    puts "Usage: #{$0} [config_name|config_file]+"
    exit( 1 )
end

system( "ant mrproper >release.log" )

ARGV.each { |filename|

    config = nil

    begin
        valid_filename = determine_config_filename( filename )
        config = Configuration.new valid_filename
        raise "Unknown problem" unless config.valid?
    rescue StandardError => e
        puts
        puts e.backtrace.join("\n")
        puts
        puts "INVALID CONFIGURATION: " + e
        exit( 10 )
    end

    begin
        build_release( config )
    rescue StandardError => e
        puts
        puts e.backtrace.join("\n")
        puts
        puts "BUILD FAILED: " + e
        system "cat release.log" if File.exist?('release.log')
        exit( 10 )
    end
}

puts
puts "Done. All configurations built."
