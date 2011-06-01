namespace :modules do

  desc "Initialize the GIT sub-modules if necessary."
  task :init do
    run "git submodule init"
  end

  desc "Update the GIT sub-modules if necessary."
  task :update do
    run "git submodule update"
  end

  desc "Show status of the GIT sub-modules."
  task :status do
    run "git submodule foreach git status"
  end

  desc "Stash changes in the GIT sub-modules."
  task :stash do
    run "git submodule foreach git stash"
  end

end
