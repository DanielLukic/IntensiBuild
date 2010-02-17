if ARGV.size < 1
    puts "Usage: #{$0} jad_file manifest_additions"
    exit( 1 )
end

exit 0 if ARGV.size == 1

target_file_name = ARGV.shift
puts target_file_name

File.open(target_file_name,'a') do |f|
    ARGV.each do |additions|
        additions.split(' || ').each do |assignment|
            k,v = assignment.split('=>')
            f.puts "#{k}: #{v}"
        end
    end
end

exit 0
