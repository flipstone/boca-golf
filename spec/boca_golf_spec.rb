require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe BocaGolf do
  it "passes if all specs passed" do
    run_specs_on_gist("def reverse(a) a.reverse; end").should be_passed
  end

  it "doesn't pass if not all specs pass" do
    run_specs_on_gist("def reverse(a) a; end").should_not be_passed
  end

  it "scores the gist" do
    run_specs_on_gist(
      "def reverse(a) a.reverse; end"
    ).score.should == 29
  end

  def run_specs_on_gist(gist)
    gist.taint
    gist.untrust if RUBY_VERSION >= "1.9"

    FakeWeb.register_uri :get, "https://gist.github.com/746166.txt", :body => gist
    stdout, stderr = StringIO.new, StringIO.new
    sandboxed do
      BocaGolf.new.run(["https://gist.github.com/746166", "spec/infrastructure/reverse_specs/spec.rb"], stdout, stderr)
    end
  end
end
