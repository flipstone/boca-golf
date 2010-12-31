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
