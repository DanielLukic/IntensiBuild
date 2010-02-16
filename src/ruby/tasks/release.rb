namespace :release do

  def all_configurations
    Dir.glob('config/*.config').sort
  end

  def default_configuration
    all_configurations.select {|c| c =~ /240x320/}.first
  end

  def release(configurations)
    scripts_folder = "modules/IntensiBuild/scripts"
    release_command = "ruby -I#{scripts_folder} #{scripts_folder}/release.rb"
    run "#{release_command} #{configurations.join(' ')}"
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
