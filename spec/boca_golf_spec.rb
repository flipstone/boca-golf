require_relative 'spec_helper'

describe BocaGolf do
  it "returns true if all specs pass" do
    run_specs_on_gist("def reverse(a) a.reverse; end").should be_true
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
