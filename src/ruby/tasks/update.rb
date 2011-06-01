
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
      data['date'] ||= Time.now.strfmt("%Y-%m-%d %H:%M:%S %Z")
      data['date'].gsub!('\\', '')

      puts "version is #{data['version']}"
      puts "date is #{data['date']}"
      puts "package is #{package}"
      puts "update url is #{data['update_url']}"

      require 'erb'

      Dir.glob("update/#{package}.*").each do |template_path|
        result = templater.process(template_path)
        writer.process(template_path, result)
        result = ERB.new(File.read(template_path)).result(data.binding)
        target_path = "deploy/update/#{File.basename(template_path)}"
        File.open(target_path, "w") { |file| file.write(result) }
        puts "erb'd #{template_path} to #{target_path}"
      end

      required = %w(.json .html)
      required.each do |extension|
        check_name = "update/" + package + extension
        next if File.exist?(check_name)

        default_path = "update/default" + extension
        result = ERB.new(File.read(default_path)).result(data.binding)

        target_path = "deploy/#{check_name}"
        File.open(target_path, "w") { |file| file.write(result) }

        puts "erb'd #{default_path} to #{target_path}"
      end

      instance_eval File.read('.intensibuild_update_rc')

      run "cp release/*.apk deploy/update/#{package}.apk"

      puts "uploading update"

      require 'net/ftp'
      Net::FTP.open(@ftp_host) do |ftp|
        ftp.login @ftp_user, @ftp_password
        ftp.chdir @ftp_folder
        Dir.glob("deploy/update/#{package}.*").each do |file_path|
          puts "uploading #{File.basename(file_path)}"
          ftp.putbinaryfile file_path
        end
      end

    end
  end

end
