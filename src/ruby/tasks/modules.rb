namespace :modules do

  def git_modules
    git_config.modules
  end

  def git_config
    require 'git/configuration'
    $git_config ||= Git::Configuration.load
  end

  def git
    require 'git/system'
    $git ||= Git::System.new git_config
  end

  def show_header(git_module)
    puts
    puts git_module
    puts git_module.to_s.gsub /./, '*'
  end

  desc "Initialize the GIT sub-modules if necessary."
  task :init do
    git_modules.each { |m| show_header m ; git.init_module(m) }
  end

  desc "Update the GIT sub-modules if necessary."
  task :update do
    git_modules.each { |m| show_header m ; git.update_module(m) }
  end

  desc "Show status of the GIT sub-modules."
  task :status do
    git_modules.each { |m| show_header m ; git.module_status(m) }
  end

  desc "Stash changes in the GIT sub-modules."
  task :stash do
    git_modules.each { |m| show_header m ; git.stash_module(m) }
  end

end
