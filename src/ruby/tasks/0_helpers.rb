def fail(message, code = 10)
  puts "failed: #{message}"
  exit code
end

def run(command)
  system(command) || fail("executing #{command}")
end
