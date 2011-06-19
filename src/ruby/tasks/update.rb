
desc "Meta task: Build a specific release and upload it plus the update data and html."
task :update, :configuration do |task, args|
  configurations = args[:configuration]
  update [configurations].flatten
end

namespace :update do

  def build_release(configuration)
    Rake::Task["release"].reenable
    Rake::Task["release"].invoke configuration
  end

  def update(configurations)
    configurations.each do |config|
      puts "updating #{config}"
      build_release config
      run "mkdir -p deploy/update"
      require 'update/properties'

      properties_file_path = Dir.glob('release/*.properties').first
      data = Properties.load(properties_file_path)

      package = data['midlet.package']
      data['package'] ||= package
      data['update_url'] ||= "http://www.intensicode.net/update/"
      data['update_folder'] ||= ""
      data['date'] ||= Time.now.strfmt("%Y-%m-%d %H:%M:%S %Z")
      data['date'].gsub!('\\', '')

      puts "version is #{data['version']}"
      puts "date is #{data['date']}"
      puts "package is #{package}"
      puts "update url is #{data['update_url']}"
      puts "update folder is #{data['update_folder']}"

      require 'fileutils'

      FileUtils.rm_rf 'deploy/update/*' rescue nil
      FileUtils.mkdir 'deploy/update/' rescue nil

      require 'erb'

      Dir.glob("update/#{package}.*").each do |template_path|
        result = templater.process(template_path)
        writer.process(template_path, result)
        result = ERB.new(File.read(template_path)).result(data.context)
        target_path = "deploy/update/#{File.basename(template_path)}"
        File.open(target_path, "w") { |file| file.write(result) }
        puts "erb'd #{template_path} to #{target_path}"
      end

      required = %w(.json .html)
      required.each do |extension|
        check_name = "update/" + package + extension
        next if File.exist?(check_name)

        default_path = "update/default" + extension
        result = ERB.new(File.read(default_path)).result(data.context)

        target_path = "deploy/#{check_name}"
        File.open(target_path, "w") { |file| file.write(result) }

        puts "erb'd #{default_path} to #{target_path}"
      end

      instance_eval File.read('.intensibuild_update_rc')

      run "cp release/*.apk deploy/update/#{package}.apk"

      puts "uploading update"

      update_folder = data['update_folder']
      ftp_folder = @ftp_folder + update_folder

      puts "ftp folder is #{ftp_folder}"

      require 'net/ftp'
      Net::FTP.open(@ftp_host) do |ftp|
        ftp.passive = true
        ftp.login @ftp_user, @ftp_password
        ftp.mkdir ftp_folder rescue nil
        ftp.chdir ftp_folder

        source_glob = "deploy/update/#{package}.*"

        Dir.glob(source_glob).each do |file_path|
           base_path = File.basename(file_path)
           puts "moving out #{base_path}"
           ftp.delete base_path + ".bak" rescue nil
           ftp.rename base_path, base_path + ".bak" rescue nil
         end

        Dir.glob(source_glob).each do |file_path|
           base_path = File.basename(file_path)
           puts "uploading #{base_path}"
           ftp.putbinaryfile file_path, base_path + ".new"
        end

        Dir.glob(source_glob).each do |file_path|
          base_path = File.basename(file_path)
          puts "moving in #{base_path}"
          ftp.rename base_path + ".new", base_path
        end

      end

    end
  end

end
