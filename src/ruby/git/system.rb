module Git

  class System

    def initialize(configuration)
      @configuration = configuration
    end

    def init_module(git_module)
      return unless git_module.is_init_required?
      remove_module(git_module) if git_module.folder_exists?
      url = determine_url_for git_module
      execute "git clone #{url} #{git_module.path}"
    end

    def update_module(git_module)
      with_validated(git_module) do
        execute "cd #{git_module.path} ; git pull"
      end
    end

    def module_status(git_module)
      with_validated(git_module) do
        execute "cd #{git_module.path} ; git status ; exit 0"
      end
    end

    def stash_module(git_module)
      with_validated(git_module) do
        execute "cd #{git_module.path} ; git stash"
      end
    end

    protected

    def with_fully_validated(git_module, &block)
      with_validated(git_module, :expected_url => determine_url_for(git_module), &block)
    end

    def with_validated(git_module, options = {}, &block)
      if git_module.is_init_required?(options)
        git_module.show_module_problems(options)
      else
        block.call
      end
    end

    def remove_module(git_module)
      execute "rm -rf #{git_module.path}"
    end

    def determine_url_for(git_module)
      relative_or_absolute_url = git_module.repository
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
