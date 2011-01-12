require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe BocaGolf::Checker do
  it "returns true if all specs pass" do
    run_specs_on_gist("def reverse(a) a.reverse; end").should be_true
  end

  it "returns false if some specs fail" do
    run_specs_on_gist("def reverse(a) a; end").should be_false
  end

  it "doesn't make methods available everywhere" do
    run_specs_on_gist "def foobar(a) a; end"
    lambda { foobar '1' }.should raise_error NoMethodError
  end

  def run_specs_on_gist(code)
    stdout, stderr = StringIO.new, StringIO.new
    sandboxed do
      BocaGolf::Checker.new.run(BocaGolf::Gist.new(code), ["spec/infrastructure/reverse_specs/spec.rb"], stdout, stderr)
    end
  end
end
