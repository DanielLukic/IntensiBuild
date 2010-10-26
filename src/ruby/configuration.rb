
class Configuration
    attr_accessor :name
    attr_accessor :targets
    attr_accessor :sizes
    attr_accessor :symbols
    attr_accessor :manifest
    attr_accessor :properties
    attr_accessor :keep

    def initialize( filename = nil )
        @name = nil
        @targets = [ Generic_JAVA ]
        @sizes = [ "240x320" ]
        @symbols = Array.new
        @keep = Array.new
        @manifest = Hash.new
        @properties = Hash.new

        parse filename if filename

        raise "Missing value for name" unless @name
    end

    def get_property( property_name )
      @properties[property_name]
    end

    def override_property( properties_hash )
      properties_hash.each do |key,value|
        @properties[key] = value
      end
    end

    def screen_orientation(mode_id)
      @symbols.delete :ORIENTATION_DYNAMIC
      @symbols.delete :ORIENTATION_PORTRAIT
      @symbols.delete :ORIENTATION_LANDSCAPE
      override_property 'config_orientation_hook' => ''
      override_property 'screen_orientation_mode' => 'unspecified'
      if mode_id == :dynamic
        override_property 'config_orientation_hook' => '|orientation'
        override_property 'screen_orientation_mode' => 'unspecified'
        @symbols << :ORIENTATION_DYNAMIC
      elsif mode_id == :landscape
        override_property 'screen_orientation_mode' => 'landscape'
        @symbols << :ORIENTATION_LANDSCAPE
      elsif mode_id == :portrait
        override_property 'screen_orientation_mode' => 'portrait'
        @symbols << :ORIENTATION_PORTRAIT
      end
    end

    def valid?
        name != nil && targets.size != 0 && sizes.size != 0
    end

    def load_config( filename )
      puts "load_config #{filename} in '#{@config_dir}'"
      filename << '.rb' unless filename =~ /\.rb$/
      parse File.join(@config_dir,filename)
    end

    def parse( filename )
        saved_config_dir = @config_dir
        @config_dir = File.dirname(filename)
        config = File.read(filename)
        instance_eval config, filename
        @config_dir = saved_config_dir if saved_config_dir
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
