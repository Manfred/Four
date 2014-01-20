require File.expand_path('test_helper', __dir__)

describe Kicker do
  it "is defined" do
    Kicker.should.be.kind_of(Class)
  end

  it "returns its version" do
    Kicker.version.should == Kicker::VERSION
  end
end