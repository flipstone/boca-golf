require_relative 'spec_helper'

describe BocaGolf::CommandLine do
  it "prints the expected result" do
    gist = "def reverse(a) a.reverse; end"
    FakeWeb.register_uri :get, "https://gist.github.com/746166.txt", body: gist
    stdout, stderr = StringIO.new, StringIO.new

    sandboxed do
      BocaGolf::CommandLine.new.run(["https://gist.github.com/746166", "spec/infrastructure/reverse_specs/spec.rb"], stdout, stderr)
    end

    stdout.string.should =~ %r|Testing https://gist.github.com/746166 against specs:
  - spec/infrastructure/reverse_specs/spec.rb

\.\.\.

Finished in \d\.\d+ seconds
3 examples, 0 failures

Code:
def reverse\(a\) a.reverse; end

Score:
29|
  end

  it "prints usage when not enough arguments are supplied" do
    stdout, stderr = StringIO.new, StringIO.new
    sandboxed do
      BocaGolf::CommandLine.new.run([], stdout, stderr)
    end

    stderr.string.should =~ %r{Usage: boca-golf file_or_gist_url spec_file \.\.\.}
  end

  it "prints useful error when file does not exist" do
    stdout, stderr = StringIO.new, StringIO.new
    sandboxed do
      BocaGolf::CommandLine.new.run(["boca-golf-foobar.rb", "spec/infrastructure/reverse_specs/spec.rb"], stdout, stderr)
    end

    stderr.string.should =~ %r{No such file or directory - boca-golf-foobar.rb}
  end
end
