class BocaGolf
  class CommandLine
    def run(args, stdout, stderr)
      gist_location, *specs = *args
      stdout.puts "Testing #{gist_location} against specs:"
      specs.each do |spec|
        stdout.puts "  - #{spec}"
      end
      stdout.puts

      result = BocaGolf.new.run args, stdout, stderr

      stdout.puts "\nCode:"
      stdout.puts result.gist.code
      stdout.puts "\nScore:"
      stdout.puts result.score
    end
  end
end
