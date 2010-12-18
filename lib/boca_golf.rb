class BocaGolf
  def run(args, stdout, stderr)
    gist_url, *rspec_args = args
    gist = Net::HTTP.get URI.parse(gist_url + ".txt")
    gist_module = Module.new
    gist_module.module_eval gist

    RSpec.configure do |config|
      config.include gist_module
    end

    RSpec::Core::Runner.run rspec_args, stderr, stdout
  end
end
