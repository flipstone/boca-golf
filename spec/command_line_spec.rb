require_relative 'spec_helper'

describe BocaGolf::CommandLine do
  it "prints the expected result" do
    gist = "def reverse(a) a.reverse; end"
    FakeWeb.register_uri :get, "http://gist.github.com/746166.txt", body: gist
    stdout, stderr = StringIO.new, StringIO.new

    sandboxed do
      BocaGolf::CommandLine.new.run(["http://gist.github.com/746166", "spec/infrastructure/reverse_specs/spec.rb"], stdout, stderr)
    end

    stdout.string.should =~ %r|Testing http://gist.github.com/746166 against specs:
  - spec/infrastructure/reverse_specs/spec.rb

\.\.\.

Finished in \d\.\d+ seconds
3 examples, 0 failures

Code:
def reverse\(a\) a.reverse; end

Score:
29|
  end
end
