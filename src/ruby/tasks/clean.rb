CLEAN_LIST = %w(release.log release.properties)

desc "Clean all temporary and generated files."
task :clean do
  require 'fileutils'
  CLEAN_LIST.each { |folder| FileUtils.rm_rf folder }
end

desc "Clean all generated files - including the really expensive ones."
task :clobber => :clean do
  require 'fileutils'
  CLOBBER_FOLDERS.each { |folder| FileUtils.rm_rf folder }
end

task :clean => 'clean:build'
#task :clean => 'clean:font_size_files'

task :clobber => 'clean:release'
task :clobber => 'clean:modules'

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
