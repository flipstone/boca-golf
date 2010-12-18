require 'bundler/setup'
require 'fakeweb'

require 'boca_golf'

FakeWeb.allow_net_connect = false

def sandboxed(&block)
  begin
    @orig_config = RSpec.configuration
    @orig_world  = RSpec.world

    new_config = RSpec::Core::Configuration.new
    new_world  = RSpec::Core::World.new(new_config)

    RSpec.instance_variable_set(:@configuration, new_config)
    RSpec.instance_variable_set(:@world, new_world)
    yield
  ensure
    RSpec.instance_variable_set(:@configuration, @orig_config)
    RSpec.instance_variable_set(:@world, @orig_world)
  end
end

describe "golf" do
  it "returns true if all specs pass" do
    FakeWeb.register_uri :get, "http://gist.github.com/746166.txt", body: "def reverse(a) a.reverse; end"
    stdout, stderr = StringIO.new, StringIO.new
    sandboxed do
      BocaGolf.new.run(["http://gist.github.com/746166", "spec/infrastructure/reverse_specs/spec.rb"], stdout, stderr)
    end.should be_true
  end

  it "returns false if some specs fail" do
    FakeWeb.register_uri :get, "http://gist.github.com/746166.txt", body: "def reverse(a) a; end"
    stdout, stderr = StringIO.new, StringIO.new
    sandboxed do
      BocaGolf.new.run(["http://gist.github.com/746166", "spec/infrastructure/reverse_specs/spec.rb"], stdout, stderr)
    end.should be_false
  end
end
