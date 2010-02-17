
def define_dependency( default_path, download_name )
    { 'default_path' => default_path, 'download_name' => download_name }
end

def load_dependencies()
    dependencies = {}
    current_dir = File.dirname( $0 )
    file_name = File.join( current_dir, 'install.dep' )
    File.open( file_name ) { |file|
        while line = file.gets
            env, path, name = line.chomp.split( /\s*\,\s*/ )
            dependencies[ env ] = define_dependency( path, name )
        end
    }
    dependencies
end
