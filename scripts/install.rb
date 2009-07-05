
require File.join( File.dirname( $0 ), 'dependencies.rb' )
require File.join( File.dirname( $0 ), 'download.rb' )



# load dependencies and set default pathes
dependencies = load_dependencies()
dependencies.each { |var, info|
    ENV[ var ] = info[ 'default_path' ] #unless ENV[ var ] != nil
}

# load credentials from .psychocell file
credentials = load_credentials( '.env_install' )
server_url = credentials['server_url'] || 'http://bx.dyndns.info/Psychocell/Install/'

# download missing dependencies
dependencies.each { |var, info|
    install_path = File.join( ENV[ var ], '..' )
    bin_dir = File.join( ENV[ var ], "bin" )
    if !test( ?d, bin_dir )
        name = info[ 'download_name' ]
        download_and_install( install_path, name, server_url + name, credentials )
    end
}

exit( 0 )
