
desc "Build a specific release."
task :release, :configuration, :needs => 'resources:font_size_files' do |task, args|
  configurations = args[:configuration]
  configurations ||= default_configuration
  release [configurations].flatten
end

namespace :release do

  def all_configurations
    config_files = Dir.glob('config/*.config')
    ruby_files = Dir.glob('config/*.rb').select {|f| not f =~ /^_[0-9]+x[0-9]\.rb$/ }
    (config_files + ruby_files).sort
  end

  def default_configuration
    raise "please specify which configuration to release"
  end

  def release(configurations)
    scripts_folder = "#{INTENSIBUILD_FOLDER}/src/ruby"
    release_command = "ruby -I#{scripts_folder} #{scripts_folder}/release.rb"
    release_command_line = "#{release_command} #{configurations.join(' ')}"
    puts release_command_line
    run release_command_line
  end

  desc "Build all releases matching config/*.config."
  task :all do
    Rake::Task['release:do'].invoke all_configurations
  end

end
