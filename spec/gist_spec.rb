require_relative 'spec_helper'

describe BocaGolf::Gist do
  describe "safe_module" do
    it "creates a module to call methods" do
      o = Object.new
      o.extend BocaGolf::Gist.new("def foobar(a) a*2; end").safe_module
      o.foobar(3).should == 6
    end

    it "evals code at safe level 4" do
      -> do
        BocaGolf::Gist.new(%{
          def reverse(a) a.reverse; end;
          class ::Object; def foo() end; end
        }).safe_module
      end.should raise_error(SecurityError)
    end

    it "calls methods at safe level 4" do
      o = Object.new.tap do |o|
        o.extend BocaGolf::Gist.new(%{
          def foo
            ::Object.class_eval { def bar() end }
          end
        }).safe_module
      end

      -> { o.foo }.should raise_error(SecurityError)
    end
  end

  describe "load_from_url" do
    it "requests the .txt version of gist" do
      code = "def a(); end"
      FakeWeb.register_uri :get, "https://gist.github.com/746166.txt", body: code
      BocaGolf::Gist.load_from_url("https://gist.github.com/746166").code.should == code
    end
  end

  describe "load_from_file" do
    it "reads the file from disk" do
      File.should_receive(:read).with("/foo/bar.rb").and_return(code = "def a(); end")
      BocaGolf::Gist.load_from_file("/foo/bar.rb").code.should == code
    end
  end

  describe "load_from_location" do
    it "loads from url when argument is a valid url" do
      code = "def a(); end"
      FakeWeb.register_uri :get, "https://gist.github.com/746166.txt", body: code
      BocaGolf::Gist.load_from_location("https://gist.github.com/746166").code.should == code
    end

    it "loads from file when argument is not a full url" do
      File.should_receive(:read).with("/foo/bar.rb").and_return(code = "def a(); end")
      BocaGolf::Gist.load_from_location("/foo/bar.rb").code.should == code
    end
  end
end
