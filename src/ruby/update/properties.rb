class Properties

    def self.load(properties_file_path)
        properties = {}
        File.readlines(properties_file_path).each do |l|
            k,v = l.sub(/\$\{(.*)\}=(.*)\n/, '\1 => \2').split(' => ')
            properties[k] = v
        end
        new(properties)
    end

    def initialize(hash)
        @data = Hash.new
        hash.each { |k,v| @data[_(k)] = v }
    end

    def binding
        Kernel.binding
    end

    def [](key)
        @data[_(key)]
    end

    def []=(key,value)
        @data[_(key)] = value
    end

    def method_missing(name, *args)
        @data[name] || "[not found: #{name}]"
    end

    private

    def _(key)
        key.gsub('.','_').to_sym
    end

end
