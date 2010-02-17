namespace :release do

  def all_configurations
    config_files = Dir.glob('config/*.config')
    ruby_files = Dir.glob('config/*.rb').select {|f| not f =~ /^_[0-9]+x[0-9]\.rb$/ }
    (config_files + ruby_files).sort
  end

  def default_configuration
    all_configurations.select {|c| c =~ /240x320/}.first
  end

  def release(configurations)
    scripts_folder = "modules/IntensiBuild/src/ruby"
    release_command = "ruby -I#{scripts_folder} #{scripts_folder}/release.rb"
    release_command_line = "#{release_command} #{configurations.join(' ')}"
    puts release_command_line
    run release_command_line
  end

  desc "Build all releases matching config/*.config."
  task :all do
    Rake::Task['release:do'].invoke all_configurations
  end

  desc "Build a specific release or the first configuration matching config/*240x320*.config."
  task :do, :configuration, :needs => 'resources:font_size_files' do |task, args|
    configurations = args[:configuration]
    configurations ||= default_configuration
    release [configurations].flatten
  end

end
