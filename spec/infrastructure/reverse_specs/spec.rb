describe "reverse" do
  it "preserves length" do
    reverse("a").length.should == 1
  end

  it "makes the first character the last" do
    reverse("abc").chars.to_a.last.should == "a"
  end

  it "makes the last character first" do
    reverse("abc").chars.to_a.first.should == "c"
  end
end
