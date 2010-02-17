
def execute( command )
    success = system( command )
    raise "Failed executing #{command}" unless success
    raise "Command #{command} failed" unless $? == 0
end

def list_to_string( list, prefix, delimiter )
    result = ''
    list.each { |entry| result += "#{prefix}#{entry}#{delimiter}" }
    result.chop
end

def hash_to_string( list, assignment, delimiter )
    result = ''
    list.each_pair do |k,v|
        result += "#{delimiter}" if result.length > 0
        result += "#{k}#{assignment}#{v}"
    end
    result
end
