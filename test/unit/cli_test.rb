require File.expand_path('../test_helper', __dir__)

describe Kicker::CLI do
  it "shows the current version" do
    capture_stdout do
      run('-v')
    end.should.include Kicker::VERSION
  end

  it "shows usage information" do
    capture_stdout do
      run('-h')
    end.should.include 'Usage:'
  end

  it "parses recipes out of the options" do
    eval(capture_stdout do
      run('--dump-options -r peck -r ignore')
    end)[:recipes].should == %w(peck ignore)
  end

  private

  def run(arg)
    Kicker::CLI.run(arg.split(' '))
  end
end