class BocaGolf
  class Checker
    def run(gist, rspec_args, stdout, stderr)
      RSpec.configure do |config|
        config.include gist.safe_module
      end

      RSpec::Core::Runner.run rspec_args, stderr, stdout
    end
  end
end
