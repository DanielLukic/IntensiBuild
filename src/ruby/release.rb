
load File.join( File.dirname( $0 ), 'build.rb' )
load File.join( File.dirname( $0 ), 'configuration.rb' )
load File.join( File.dirname( $0 ), 'target.rb' )



load File.join( File.dirname( $0 ), '..', '..', 'config', '_groups.rb' )
load File.join( File.dirname( $0 ), '..', '..','config', '_targets.rb' )

if ARGV.size == 0
    puts "Usage: #{$0} [config_name|config_file]+"
    exit( 1 )
end

system( "ant mrproper >release.log" )

ARGV.each do |filename|

    config = nil

    begin
        config_name = filename.sub(/:.*/,'')
        facets = filename.sub(/[^:]*:/, '').split(':') - [config_name]
        valid_filename = determine_config_filename(config_name)
        config = Configuration.new(valid_filename)
        facets.each {|facet| config.load_config File.join('facet',facet + '.rb')}
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
end

puts
puts "Done. All configurations built."
