# encoding: utf-8
require_relative 'spec_helper'

describe BocaGolf::Scorer do
  describe "score" do
    it "returns the length of code" do
      subject.score(BocaGolf::Gist.new("abc123")).should == 6
    end

    it "returns the counts characters rather than bytes" do
      subject.score(BocaGolf::Gist.new("abc♥")).should == 4
    end
  end
end
