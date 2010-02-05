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

  desc "Initialize the GIT sub-modules if necessary."
  task :init do
    git_modules.each { |m| git.init_module(m) }
  end

  desc "Update the GIT sub-modules if necessary."
  task :update do
    git_modules.each { |m| git.update_module(m) }
  end

  desc "Show status of the GIT sub-modules."
  task :status do
    git_modules.each do |m|
      puts
      puts m
      puts m.to_s.gsub /./, '*'
      git.module_status(m)
    end
  end

#  desc "Reset the GIT sub-modules by removing any local changes."
#  task :reset do
#    git_modules.each { |m| git.reset_module(m) }
#  end

#  desc "Delete the GIT sub-modules by removing the folders."
#  task :delete do
#    git_modules.each { |m| git.delete_module(m) }
#  end

end
