require 'git/module'

module Git

  class Configuration

    GITMODULES_PATH = '.gitmodules'

    COMMENT_REGEX = /^[ \t]*#/
    COMMAND_REGEX = /^[a-z_]+\:.+/

    attr_reader :modules
    attr_reader :remote_url

    def self.load(path_prefix = '.')
      config = new path_prefix
      config.load_remote_url if config.has_remote_url?
      config.load_modules if config.has_modules?
      config
    end

    def initialize(path_prefix)
      @path_prefix = path_prefix
    end

    def has_remote_url?
      load_remote_url
    rescue
      false
    end

    def has_modules?
      File.exist?(file_path(GITMODULES_PATH))
    end

    def load_remote_url(path = '.git/config')
      lines = readlines(path)
      urls = lines.select { |l| l =~ /^[ \t]*url[ \t]*=/ }
      raise "missing remote url in #{path}" unless urls && urls.size > 0
      @remote_url = urls.first.split('=').last.strip
    end

    def load_modules(path = GITMODULES_PATH)
      lines = readlines(path)
      lines.each do |l|
        next if l =~ COMMENT_REGEX
        next unless l =~ COMMAND_REGEX
        colon_pos = l.index(':')
        command = l[0, colon_pos]
        data = l[colon_pos + 1, l.length]
        send command.to_sym, *data.split(' ')
      end
    end

    def remote_override(url_pattern)
      @remote_override = url_pattern
    end

    def add_module(repository, path)
      @modules ||= []
      @modules << Git::Module.new(repository, path)
    end

    def create_module_url(relative_module_url)
      if has_remote_override
        create_url_from_pattern(relative_module_url)
      else
        determine_base_url + '/' + relative_module_url
      end
    end

    def has_remote_override
      @remote_override
    end

    def create_url_from_pattern(relative_module_url)
      @remote_override.gsub "{{module}}", relative_module_url
    end

    def determine_base_url
      last_slash = @remote_url.rindex '/'
      return remote_url unless last_slash
      @remote_url[0,last_slash]
    end

    private

    def readlines(path)
      File.readlines(file_path(path))
    end

    def file_path(path)
      File.join(@path_prefix, path)
    end

  end

end
