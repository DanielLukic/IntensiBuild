namespace :clean do

  desc "Remove the build folder."
  task :build do
    run "rm -rf build"
  end

  desc "Remove the release folder."
  task :release do
    run "rm -rf release"
  end

  desc "Remove the font size data files."
  task :font_size_files do
    run "rm -f res/*/*/*.dst"
  end

  desc "Remove the sub modules."
  task :modules => 'modules:delete' do
    # nothing else
  end

end
