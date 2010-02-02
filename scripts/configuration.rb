
class Configuration
    attr_accessor :name
    attr_accessor :targets
    attr_accessor :sizes
    attr_accessor :symbols
    attr_accessor :manifest

    def initialize( filename = nil )
        @config_dir = File.dirname filename

        @name = nil
        @targets = [ Generic_JAVA ]
        @sizes = [ "240x320" ]
        @symbols = ''
        @manifest = {}

        parse filename if filename

        raise "Missing value for name" unless @name
    end

    def valid?
        name != nil && targets.size != 0 && sizes.size != 0
    end

    def load_config( filename )
      parse( File.join( @config_dir, filename ) )
    end

    def parse( filename )
        File.open( filename ) do |file|
            while line = file.gets
                next if line.strip!.empty?
                next if line =~ /^\s*\#/
                eval line
            end
        end
    end
end

def determine_config_filename( filename )
    check = filename
    return check if test( ?f, check )
    check = filename + '.rb'
    return check if test( ?f, check )
    check = File.join( 'config', filename )
    return check if test( ?f, check )
    check = File.join( 'config', filename + '.rb' )
    return check if test( ?f, check )
    check = File.join( 'config', 'construction', filename )
    return check if test( ?f, check )
    check = File.join( 'config', 'construction', filename + '.rb' )
    return check if test( ?f, check )

    raise "Unknown configuration: " + filename
end
