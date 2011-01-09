class BocaGolf
  class CommandLine
    def run(args, stdout, stderr)
      ::Rspec::Core::Runner.disable_autorun!

      if args.size > 1
        run_with_checked_args args, stdout, stderr
      else
        show_usage stdout, stderr
      end
    end

    def run_with_checked_args(args, stdout, stderr)
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

    def show_usage(stdout, stderr)
      stderr.puts "Usage: boca-golf file_or_gist_url spec_file ..."
    end
  end
end
