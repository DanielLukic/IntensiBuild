
require File.join( File.dirname( $0 ), 'common.rb' )



def load_credentials( file_name )
    credentials = { 'login' => 'psychocell', 'password' => nil }
    File.open( file_name ) { |file|
        while line = file.gets
            key, value = line.chomp.split( /\s*\=\s*/ )
            credentials[ key ] = value
        end
    }
    credentials
end

def download_and_install( install_path, name, url, credentials )
    download( name, url, credentials )
    execute( "unzip -oq #{name} -d #{install_path}" )
    execute( "rm -f #{name}" )
end

def download( name, url, credentials )
    puts "Downloading #{name} from #{url}"
    login = credentials[ 'login' ]
    password = credentials[ 'password' ]
    execute( "rm -f #{name}" )
    execute( "wget -O #{name} --http-user=#{login} --http-passwd=#{password} #{url}" )
end
