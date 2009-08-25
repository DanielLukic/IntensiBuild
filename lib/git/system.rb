module Git

  class System

    def initialize(configuration)
      @configuration = configuration
    end

    def init_module(git_module)
      return unless is_init_required?(git_module)
      remove_module(git_module) if git_module.folder_exists?
      url = determine_repository_url git_module.repository
      execute "git clone #{url} #{git_module.path}"
    end

    def update_module(git_module)
      return if is_init_required?(git_module)
      execute "cd #{git_module.path} ; git pull"
    end

    def module_status(git_module)
      return if is_init_required?(git_module)
      execute "cd #{git_module.path} ; git status ; exit 0"
    end

    def reset_module(git_module)
      return if is_init_required?(git_module)
      execute "cd #{git_module.path} ; git checkout . ; git clean -f"
    end

    def delete_module(git_module)
      return if is_init_required?(git_module)
      execute "rm -rf #{git_module.path}"
    end

    def is_init_required?(git_module)
      return true unless git_module.folder_exists?
      return true unless is_proper_git_module?(git_module.path)
      return true unless repository_url_matches?(git_module)
      return false
    end

    def remove_module(git_module)
      execute "rm -rf #{git_module.path}"
    end

    def is_proper_git_module?(path)
      return false unless File.exist?(path)
      return false unless File.exist?(File.join(path, '.git'))
      return false unless File.exist?(File.join(path, '.git', 'config'))
      return true
    end

    def repository_url_matches?(git_module)
      expected_url = determine_repository_url git_module.repository
      module_config = @configuration.class.load git_module.path
      module_url = module_config.remote_url
      return expected_url == module_url
    end

    def determine_repository_url(relative_or_absolute_url)
      return relative_or_absolute_url if has_protocol(relative_or_absolute_url)
      return relative_or_absolute_url if starts_with_slash(relative_or_absolute_url)
      @configuration.create_module_url(relative_or_absolute_url)
    end

    def has_protocol(url)
      url =~ /^[a-z]+:\/\//
    end

    def starts_with_slash(url)
      url =~ /^\//
    end

    def execute(commandline)
      system(commandline) || raise("failed executing #{commandline}")
    end

  end

end
