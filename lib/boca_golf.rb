class BocaGolf
  def run(args, stdout, stderr)
    gist_url, *rspec_args = args
    gist = Net::HTTP.get URI.parse(gist_url + ".txt")

    gist_module = lambda do
      $SAFE = 4
      Module.new.tap {|m| m.module_eval gist}
    end.call

    safe_proxy = Module.new
    gist_module.instance_methods.each do |method|
      safe_proxy.module_eval %{
        def #{method}(*args, &block)
          lambda do
            $SAFE = 4
            super
          end.call
        end
      }
    end

    RSpec.configure do |config|
      config.include gist_module
      config.include safe_proxy
    end

    RSpec::Core::Runner.run rspec_args, stderr, stdout
  end
end
