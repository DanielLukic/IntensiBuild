require 'erb'
require 'fileutils'
require File.join( File.dirname( $0 ), 'common.rb' )



def build_release( config )
    name = config.name

    puts
    puts "Building #{name}"
    puts

    config.targets.each { |target| build_target( config, target ) }

    FileUtils.rm_f [ 'transitions.properties' ]
end

def build_target( config, target )
    puts "  Building for #{target}"

    config.sizes.each { |size| build_instance( config, target, size ) }

    FileUtils.rm_f [ 'script.java' ]
end

def build_instance( config, target, size )
    puts "    Building for screensize #{size}"

    FileUtils.rm_f [ 'release.properties', 'release.log' ]

    name = config.name
    write_release_properties( config, target, size )

    defines = ''
    defines << "-Dwtk.home=#{ENV['WTK_HOME']}" if ENV['WTK_HOME']
    defines << "-Dtoasted=tested" unless ENV['WTK_HOME']
    commandline = "ant #{defines} release >release.log 2>&1"

    success = system( commandline )
    raise "See release.log for error messages!" unless $? == 0
    raise "Please check environment: Failed starting ant!" unless success

    File.open( 'release.log' ) do |file|
        while line = file.gets
            raise "See release.log for error messages!" if line =~ /^BUILD FAILED/
        end
    end

    FileUtils.rm_f [ 'release.properties', 'release.log' ]
end

def write_release_properties( config, target, screen_size )

    config_symbols = nil

    if config.symbols.class == Array
        config_symbols = config.symbols
    else
        config_symbols = config.symbols.split( /\s*,\s*/ )
    end

    symbols = config_symbols + target.symbols
    defined_symbols = list_to_string( symbols, '', ',' )
    jar_suffix = target.name.gsub( /[^\w]/, '_' )
    jar_suffix = jar_suffix.split('_').uniq.join('_')

    attributes = config.manifest
    attributes.merge! target.manifest
    manifest_additions = hash_to_string( config.manifest, '=>', ' || ' )

    available_libs = target.libs.select {|lib| File.exist?(File.join("modules/IntensiBuild/lib/devices", lib))}
    build_libs = list_to_string( available_libs, '${dir.intensibuild}/lib/devices/', ';' )

    name = config.name
    output_name = name.gsub( / /, '_' )

    if symbols.include?(:DEBUG)
        obfuscate = false
        debug = true
        jar_suffix << '-DEBUG'
    else
        obfuscate = true
        debug = false
    end

    template_filepath = File.join( File.dirname( $0 ), 'release_template.erb' )
    template = ERB.new(File.read(template_filepath))
    release_properties = template.result(binding)
    File.open( 'release.properties', "w" ) { |file| file.puts release_properties }

end
