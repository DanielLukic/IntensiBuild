require 'git/configuration'

module Git

  class Module

    attr_reader :repository
    attr_reader :path

    def initialize(repository, path)
      @repository = repository
      @path = path
    end

    def folder_exists?
      File.exist?(path)
    end

    def is_proper?
      return false unless File.exist?(path)
      return false unless File.exist?(File.join(path, '.git'))
      return false unless File.exist?(File.join(path, '.git', 'config'))
      return true
    end

    def is_init_required?(options = {})
      return true unless folder_exists?
      return true unless is_proper?
      return true if options[:expected_url] and not configured_url == options[:expected_url]
      return false
    end

    def configured_url
      configuration = Git::Configuration.load path
      configuration.remote_url
    end

    def to_s
      @path
    end

  end

end
