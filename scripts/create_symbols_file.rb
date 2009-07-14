require 'optparse'
require 'ostruct'

class Options
    def initialize
        @options = OpenStruct.new
        @options.verbose = false
        @options.output = 'build/symbols.txt'
        @options.symbols = []
    end

    def parse(commandline)
        options = OptionParser.new
        options.on('-v', '--verbose')             { |arg| @options.verbose = true }
        options.on('-o', '--output FILENAME')     { |arg| @options.output = arg }
        options.on('-s', '--symbols SYM,SYM,..')  { |arg| add_symbols arg }
        options.on('-d', '--define KEY=VAL')      { |arg| add_symbol arg }
        options.parse!(commandline)

        if @options.verbose
            puts '-'*20
            puts "Output:   #{@options.output}"
            puts "Symbols:  #{@options.symbols.join(',')}"
            puts '-'*20
        end

        @options
    end

    def add_symbols(comma_separated_symbols)
        symbols = comma_separated_symbols.split(',')
        symbols.each do |sym|
            puts "Setting #{sym}" if @options.verbose
            @options.symbols << sym
        end
    end

    def add_symbol(key_and_optional_value)
        parts = key_and_optional_value.split('=')
        if parts.length == 1
            @options.symbols << parts[0]
        elsif parts.length == 2
            key,value = parts
            # Ignore 'unset' Antenna properties. In this case the definition
            # looks like key=${name} but the named property is not set in Antenna.
            # We consider this 'not set' here.
            unless value =~ /\$\{.+\}/
                puts "Setting #{key} to #{value}" if @options.verbose
                @options.symbols << "#{key}=#{value}"
            else
                puts "Unsetting #{key}" if @options.verbose
                @options.symbols << "unset@#{key}"
            end
        else
            raise "unsupported symbol definition: #{key_and_optional_value}"
        end
    end
end

options = Options.new.parse(ARGV)

File.open(options.output,'w') do |file|
    options.symbols.each do |symbol|
        file.puts symbol
    end
end
