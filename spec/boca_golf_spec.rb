require 'bundler/setup'
require 'fakeweb'

require 'boca_golf'

FakeWeb.allow_net_connect = false

module RSpecTestHelper
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
end

RSpec.configure do |c|
  c.include RSpecTestHelper
end

describe BocaGolf do
  it "returns true if all specs pass" do
    run_specs_on_gist("def reverse(a) a.reverse; end").should be_true
  end

  it "returns false if some specs fail" do
    run_specs_on_gist("def reverse(a) a; end").should be_false
  end

  it "doesn't make methods available everywhere" do
    run_specs_on_gist "def foobar(a) a; end"
    -> { foobar '1' }.should raise_error NoMethodError
  end

  it "evals code at safe level 4" do
    lambda do
      run_specs_on_gist("def reverse(a) a.reverse; end; class ::Object; def foo() end; end")
    end.should raise_error(SecurityError)
  end

  it "calls methods at safe level 4" do
    run_specs_on_gist("def reverse(a) ::Object.class_eval { def foo() end }; a.reverse; end").should be_false

    lambda do
      Object.new.foo
    end.should raise_error(NoMethodError)
  end

  def run_specs_on_gist(gist)
    gist.taint
    gist.untrust

    FakeWeb.register_uri :get, "http://gist.github.com/746166.txt", body: gist
    stdout, stderr = StringIO.new, StringIO.new
    sandboxed do
      BocaGolf.new.run(["http://gist.github.com/746166", "spec/infrastructure/reverse_specs/spec.rb"], stdout, stderr)
    end
  end
end
