namespace :check do

  COMMANDS=%w(git groovy jruby)

  def check(command)
    success = system "which >/dev/null #{command}"
    fail "#{command} not available" unless success
  end

  COMMANDS.each do |command|
    task command.to_sym do
      check command
    end
  end

end
